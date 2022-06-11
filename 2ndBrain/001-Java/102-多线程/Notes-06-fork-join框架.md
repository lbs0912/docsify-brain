

# Notes-06-fork/join框架


[TOC]




## 更新
* 2020/10/03，撰写
* 2020/10/11，内容完善


## 参考资料
* 书籍《Java 8实战》第7章-分支/合并框架
* [ForkJoinPool大剖析](https://dayarch.top/p/java-fork-join-pool.html)
* [聊聊并发（八）——Fork/Join框架介绍](https://www.infoq.cn/article/fork-join-introduction)
* [Java并发 - Fork/Join框架介绍](https://wangxin1248.github.io/java/2019/10/forkjoin.html)
* [双端队列和工作窃取](https://houbb.github.io/2019/01/18/jcip-14-deque-workstealing)



## 什么是Fork/Join框架

`Fork/Join` 框架，即分支/合并框架，是 Java 7 中提供的一个用于并行执行任务的框架，是一个把大任务分割成若干个小任务，最终汇总每个小任务结果后得到大任务结果的框架。

`Fork/Join` 框架，和 `MapReduce` 的原理类似，都是通过将大任务拆分为小任务来实现并行计算，主要是利用**分治法**的思想来实现多任务并行计算。
* `Fork` 就是把一个大任务切分为若干子任务并行的执行
* `Join` 就是合并这些子任务的执行结果，最后得到这个大任务的结果。


`Fork/Join` 的运行流程图如下。


![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/back-end-2020/java-fork-join-task-1.png)




![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/back-end-2020/java-fork-join-task-1-1.png)


`Fork/Join` 框架创建的任务需要通过 `ForkJoinPool` 来启动，`ForkJoinPool` 是一个线程池，比较特殊的是其线程数量是根据 CPU 的核心数来设置的。`ForkJoinPool` 是通过**工作窃取（`work-stealing`）算法**来提高 CPU 的利用率的。






## 工作窃取算法



工作窃取（`work-stealing`）算法是指某个线程从其他队列里窃取任务来执行。工作窃取的运行流程图如下。


![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/back-end-2020/java-fork-join-task-3.png)




![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/back-end-2020/java-fork-join-task-1-2.png)


每个线程中维护了一个双端队列来存储所需要执行的任务，而工作窃取算法允许从其他线程的双端队列中窃取一个**最晚（`Oldest`，队列的尾部）** 的任务来执行，这样可以避免和当前任务所属的线程发生竞争。


> 为了减少窃取任务线程和被窃取任务线程之间的竞争，通常会使用双端队列，被窃取任务线程永远从双端队列的头部拿任务执行，而窃取任务的线程永远从双端队列的尾部拿任务执行。

如上图所示，Thread2 从 Thread1 队列中拿出最晚的 Task1 来执行，Thread1 则拿出 Task2 来执行，这样就会避免发生竞争。




工作窃取算法优点
* 充分利用线程进行并行计算
* 减少了线程间的竞争

工作窃取算法缺点
* 在某些情况下会存在竞争（双端队列中只有一个任务）
* 消耗了更多的系统资源



在实际应用中，工作窃取算意味着这些任务差不多被平均分配到 `ForkJoinPool` 中的所有线程上，用于在池中的工作线程之间重新分配和平衡任务。下图展示了这个过程，当工作线程队列中有一个任务被分成两个子任务时，一个子任务就被闲置的工作线程“偷走”了。如前所述，这个过程可以不断递归，直到规定子任务应顺序执行的条件为真。


![](https://image-bed-20181207-1257458714.cos.ap-shanghai.myqcloud.com/back-end-2020/java-fork-join-task-2.png)




## Fork/Join框架基础类


下面考虑如何设计一个 `Fork/Join` 框架，需要考虑如下 2 点

1. 第 1 步分割任务。首先需要有一个 `fork` 类来把大任务分割成子任务，有可能子任务还是很大，所以还需要不停的分割，直到分割出的子任务足够小。

2. 第 2 步执行任务并合并结果。分割的子任务分别放在双端队列里，然后几个启动线程分别从双端队列里获取任务执行。子任务执行完的结果都统一放在一个队列里，启动一个线程从队列里拿数据，然后合并这些数据。


`Fork/Join` 使用 2 个类来完成以上两件事情

* `ForkJoinTask`：我们要使用 `Fork/Join` 框架，必须首先创建一个 `ForkJoinTask` 任务。它提供在任务中执行 `fork()` 和 `join()` 操作的机制。通常情况下我们不需要直接继承 `ForkJoinTask` 类，而只需要继承它的子类，`Fork/Join` 框架提供了以下两个子类
    - `RecursiveAction`：用于没有返回结果的任务。
    - `RecursiveTask` ：用于有返回结果的任务。
* `ForkJoinPool` ：`ForkJoinTask` 需要通过 `ForkJoinPool` 来执行，任务分割出的子任务会添加到当前工作线程所维护的双端队列中，进入队列的头部。当一个工作线程的队列里暂时没有任务时，它会随机从其他工作线程的队列的尾部获取一个任务。



此外，框架还提供了下面 2 个类
* `ForkJoinWorkerThread`：是 `ForkJoinPool` 内的 `worker thread`，执行 `ForkJoinTask`，内部有 `ForkJoinPool.WorkQueue` 来保存要执行的 `ForkJoinTask`。
* `ForkJoinPool.WorkQueue`：保存要执行的 `ForkJoinTask`。


更形象的总结如下
1. `ForkJoinPool` : “管理者”
2. `ForkJoinTask` : “任务类型”，如 `RecursiveAction` 和 `RecursiveTask`
3. `ForkJoinWorkerThread` : “工人”



## Fork/Join 框架执行流程


```java
// fork/join计算斐波那契


//创建分治任务线程池
ForkJoinPool fjp = new ForkJoinPool(4);

//创建分治任务
Fibonacci fib = new Fibonacci(30);

//启动分治任务
Integer result = fjp.invoke(fib);




// 如何提交
submit(ForkJoinTask<T> task) ->externalPush(ForkJoinTask<?> task) ->  externalSubmit(ForkJoinTask<?> task)

execute(ForkJoinTask)
invoke(ForkJoinTask)

// 任务消费
compute()
```



1. `ForkJoinPool` 的每个工作线程都维护着一个双端工作队列（`WorkQueue`），队列中存放着是任务（`ForkJoinTask`）。
2. 每个工作线程在运行中产生新的任务（调用 `fork()`）时，放入工作队列的队首（**队首的任务的等待时间最短**），并且工作线程在处理自己的工作队列时，使用的是 `FIFO` 方式，也就是说每次从队首取出任务来执行。
3. 每个工作线程在处理自己的工作队列同时，会尝试窃取一个任务（或是来自于刚刚提交到 `pool` 的任务，或是来自于其他工作线程的工作队列），窃取的任务位于其他线程的工作队列的队尾，也就是说工作线程在窃取其他工作线程的任务时，使用的是 `LIFO` 方式。
4. 在遇到 `join()` 时，如果需要 `join` 的任务尚未完成，则会先处理其他任务，并等待其完成。
5. 在既没有自己的任务，也没有可以窃取的任务时，进入休眠。



> FIFO : First in, First out，先进先出。 LIFO : Last in, First out，后进先出。

## Fork/Join 使用Demo

```java
public class CountTest {
    public static void main(String[] args) throws InterruptedException, ExecutionException {

        ForkJoinPool forkJoinPool = new ForkJoinPool();
        //创建一个计算任务，计算 由1加到12
        CountTask countTask = new CountTask(1, 12);
        Future<Integer> future = forkJoinPool.submit(countTask);
        System.out.println("最终的计算结果：" + future.get());
    }
}

class CountTask extends RecursiveTask<Integer> {

    private static final int THRESHOLD = 2;
    private int start;
    private int end;


    public CountTask(int start, int end) {
        this.start = start;
        this.end = end;
    }

    @Override
    protected Integer compute() {
        int sum = 0;
        boolean canCompute = (end - start) <= THRESHOLD;

        //任务已经足够小，可以直接计算，并返回结果
        if (canCompute) {
            for (int i = start; i <= end; i++) {
                sum += i;
            }
            System.out.println("执行计算任务，计算    " + start + "到 " + end + "的和  ，结果是：" + sum + "   执行此任务的线程：" + Thread.currentThread().getName());

        } else { //任务过大，需要切割
            System.out.println("任务过大，切割的任务：  " + start + "加到 " + end + "的和       执行此任务的线程：" + Thread.currentThread().getName());
            int middle = (start + end) / 2;
            //切割成两个子任务
            CountTask leftTask = new CountTask(start, middle);
            CountTask rightTask = new CountTask(middle + 1, end);
            //执行子任务
            leftTask.fork();
            rightTask.fork();
            //等待子任务的完成，并获取执行结果
            int leftResult = leftTask.join();
            int rightResult = rightTask.join();
            //合并子任务
            sum = leftResult + rightResult;
        }
        return sum;
    }
}


```


程序运行结果如下


```json
任务过大，切割的任务： 1加到 12的和 执行此任务的线程：ForkJoinPool-1-worker-1
任务过大，切割的任务： 7加到 12的和 执行此任务的线程：ForkJoinPool-1-worker-3
任务过大，切割的任务： 1加到 6的和 执行此任务的线程：ForkJoinPool-1-worker-2
执行计算任务，计算 7到 9的和 ，结果是：24 执行此任务的线程：ForkJoinPool-1-worker-3
执行计算任务，计算 1到 3的和 ，结果是：6 执行此任务的线程：ForkJoinPool-1-worker-1
执行计算任务，计算 4到 6的和 ，结果是：15 执行此任务的线程：ForkJoinPool-1-worker-1
执行计算任务，计算 10到 12的和 ，结果是：33 执行此任务的线程：ForkJoinPool-1-worker-3
最终的计算结果：78

```

从结果可以看出，提交的计算任务是由线程1执行，线程1进行了第一次切割，切割成两个子任务 “7加到12” 和 “1加到6”，并提交这两个子任务。然后这两个任务被线程2、线程3给窃取了。线程1 的内部队列中已经没有任务了，这时候，线程2、线程3 也分别进行了一次任务切割并各自提交了两个子任务，于是线程 1 也去窃取任务（这里窃取的都是线程2的子任务）。





## Fork/Join 框架的异常处理

`ForkJoinTask` 在执行的时候可能会抛出异常，但是我们没办法在主线程里直接捕获异常，所以 `ForkJoinTask` 提供了 `isCompletedAbnormally()` 方法来检查任务是否已经抛出异常或已经被取消了，并且可以通过 `ForkJoinTask` 的 `getException` 方法获取异常。使用如下代码


```java
if(task.isCompletedAbnormally()) {
   System.out.println(task.getException());
}
```


`getException` 方法返回 `Throwable` 对象，如果任务被取消了则返回 `CancellationException`。如果任务没有完成或者没有抛出异常则返回 `null`。




## FAQ


### ForkJoinPool 使用 submit 与 invoke 提交的区别
* `invoke` 是同步执行，调用之后需要等待任务完成，才能执行后面的代码。
* `submit` 是异步执行，只有在 `Future` 调用 `get` 的时候会阻塞。


### 继承 RecursiveTask 与 RecursiveAction的区别？
* 继承 `RecursiveTask`：适用于有返回值的场景。
* 继承 `RecursiveAction`：适合于没有返回值的场景。


### 子任务调用 fork 与 invokeAll 的区别？

* `fork`：让子线程自己去完成任务，父线程监督子线程执行，浪费父线程。
* `invokeAll`：子父线程共同完成任务，可以更好的利用线程池。