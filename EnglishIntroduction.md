# introducton in English

## questions on resume

### 1 Tell me about yourself

  Good afternoon, I am glad to have this opportunity. I come from Hubei Province. I received a Bachelor's degree in Biology Engineering from Yanshan University in 2005, and received a Master’s degree in Chemistry from Tsinghua University in 2011.
  I did work related to biology for nearly 5 years, then I turn to be a java programmer. Now I have worked as a java programmer for six years. The business of last company is credit business.

  I have been a Java Developer for 6 years now and since I first started work, I have constantly sought to improve and develop my skills.
  I am proficient with programming languages; I have an inquisitive nature that ensures I analyze my work and the problems I encounter in detail; I am quick to learn new concepts and can apply them to a variety of situations, and I am a strong team worker who can collaborate with and work alongside others to complete challenging projects and also resolve complex issues and problems.
  I am highly self-motivated, technically astute and you can rely on me to get up to speed quickly in the role whilst being a cooperative, responsive and adaptable member of your team.

  That’s all, thank you for giving me the chance.

### 2 personality may use

  Adaptable、Ambitious、Creative、Curious、Competitive、Determined、Diligent、Energetic、Enthusiastic、Efficient、Flexible、Focused、Hard-working、Helpful、Honest、Innovative、Independent、Motivated、Open-minded、Organized、Punctual、Passionate、Pro-active、Reliable、Systematic、Sincere、Team Player…

### 3 How would you describe yourself? (character/personality)

  I am helpful. One day, a colleague,just an acquaintance came to me, asked me some questions about javascript. I was confused why somebody told him that I may know a little about javascript even thouth I really was. The problem solved. I never asked him who sent him to me, because I was happy when I could help him.

  I’m a person who likes learning and continually improving.
  I’m extremely dedicated to my work. For example, I'm the last one in the list resposible for solving problem happen in the evening, but everytime there is a question, I was woke up. because the people in front of me in the list turn off their phone on purpose.

### 4 What are your strengths / weaknesses?

  One of my strengths is self-discipline, during the weekend, I can stay at home all day, read books or study online.
  Self confidence and Persistence are also my strengths, without them, I can not persist to study java and become a java programmer.
  My greatest weakness is that I am a shy and nervous person. The result is that I have a difficult time speaking in front of people.
  Well, my attention to details rather than the big picture sometimes irritates my co-workers.

### 5 What do you do in your free time?

 As a career changer, I have a lot of knowledge about programming to study. So, In my spare time, I often stay in the house, read books of programming, read source code of jdk and other open source project like spring, dubbo, mybatis and so on.

### 6 What are your hobbies ? Do you have any hobbies?

  My hobby is playing badminton, because it's interesting and much safer than basket ball that body contact is inevitable, which sometimes is dangerous.

### 7 What is your greatest accomplishment ?

  I fixed a bug that exists 6 years ago. One service of PFS crash frequently every 10 days. The solution was restart the service every week manually before it crash. By analyzing the log, I found the reason is the use of The XStream class. It is a class we use to transform xml to java bean. In the method xmlToBean(), we create a new XStream instance by default constructor; This constructor create a new CompositeClassLoader.This means every time the method is called, a new XStream instance and a new CompositeClassLoader instance are created. However, minor gc won’t collect this classloader. As more and more this classloader created and stayed in memory, the system will crash and throw out of memory error. The fix is simple, I use a concurrentHashMap to restore different XStream, so every different object has only one XStream instance and one CompositeClassLoader. Now there is no need to restart that service manually.

### 8 What failures have you had? Have you had any negative experiences?

  When I worked in Pin'an Bank, that was the second year I had worked as a programmer, there was a task named annual expense summary. The data was imported into oracle table by a bigdata tool. We just need to query a customer's data and return it to the front-end. But our manager wanted to use mongodb, so we need to query all data from oracle table and insert into MongoDB collection. we dealt it in java code: used ThreadPool with 5 threads. The code had been reviewed by teammates before merged into master branch and deployed in production environment.
  I stayed up all night in the company, waiting for the result, but unfortunately, it failed. After analyzing, the manager gave up using mongodb, just query data from oracle table.

### 9 What problem have you had ? How did you solve it ?

  There is a small system which architecture is a full copy of the loan system. The role of the GMP system is to start all batch tasks at 0:00 everyday. Like a linkedlist, if current task failed, the next one will not start. The monitor system will notice this and alert until the problem solved. So the GMP system is neccesary.
  But in this small system, it's different. The tasks are independant, but if one task failed, other tasks will not start. This is not rational. After solved this problem several times, I want to settle this forever. Apparently, gmp system is not necessary in this situation.
  Because all tasks are independant, we can use schedule task instead. I discussed this with my leader, he agreed with me. It took me a week to optimize the code and test. Finally, we deployed the new code to the production environment, the problem solved.

### 10 What would you do in your 5 years ?

  My short term goal is to get a job in a reputed company where I can utilize my skills and improve my career path.
  My long term goal is to be in respectable position in thata organization.
  
  I will keep studying and try my best to be in respectable position in that organization.

### 11 Why did you leave your last job/want to leave your present role?

  The company downsized several times because there is no much work to do. I don't want to sit around and waste my time. and I have a strong desire to gain international experience. So it's time for me to leave and seek the new chance.

### 12 The reasons you want to change career

  There are 2 reasons: First, too many job-hunters in biology industry, too few jobs companies can supply. Second, I don’t want to do biology experiment in the lab.
  
  I am interested in computer science and coding. I found it when I was a sophomore, but I didn't have enough money to buy a computer. I learn the C language in the library computer center. When I was a graduate student, I borrowed 5 thousand yuan from my roommate to buy a computer and promised to repay 500 monthly. That's my first computer.
  Then I continued to learn C language, just because it's the only language I was familiar with. As java became popular that time, I began to learn java. However, what I learned is the basic knowledge of java, not study any frameworks like spring, mybatis. I can't spend much time on java, because of the experiment. We had to do many experiments and write paper.
  However, when I worked as a drug researcher, I realized that I was not enthusiastic in this area, I wanted to change my career. But all family and friends told me don't take the interest as a career, giving up what you learned so many years was a big lost. I hesitated. I don't wont to regret when I have the choice, so I decided to become a java programmer. After learning several frameworks such as spring, struts, hibernate, I began to find a job as a programmer.

### 13 Do you think the experience before you change your career is helpful to your current job ?

  Yes, knowledge in a particular area, learned in university, can enable a person be engaged into a job quickly. But the way of thinking and the ability of continuous learning are more important than the concrete knowledge. When I was in university, I gradually got the ability of continuous learning. This is important and helpful to my whole life, of course helpful to my current job.

### 14 What are your key skills?

  I have 6 years experience as a java programmer, I am resposible for 3 subsystems of the credit system which is a distributed service system consists of microservices.

  Salary has never been big issues for me. Still I am expecting salary as company's norms as per my designation and my qualification and experience, which will fulfill my economical needs.

### 15 Why do you want to work for our company as a Java Developer ?

  Although I do get engrossed in my work as a Java Developer, the company I work for is still very important to me.
  I must feel supported in my work; I want to feel like I am continually growing and improving, and I want to know that I am contributing to the wider team goals.

### 15 what's New in JDK8 ?

* Java Programming Language
  * Lambda Expressions, a new language feature, has been introduced in this release. They enable you to treat functionality as a method argument, or code as data. Lambda expressions let you express instances of single-method interfaces (referred to as functional interfaces) more compactly.
  * Method references provide easy-to-read lambda expressions for methods that already have a name.
  * Default methods enable new functionality to be added to the interfaces of libraries and ensure binary compatibility with code written for older versions of those interfaces.
  * Repeating Annotations provide the ability to apply the same annotation type more than once to the same declaration or type use.
  * Type Annotations provide the ability to apply an annotation anywhere a type is used, not just on a declaration. Used with a pluggable type system, this feature enables improved type checking of your code.
  * Improved type inference.
  * Method parameter reflection.

* Collections
  * Classes in the new java.util.stream package provide a Stream API to support functional-style operations on streams of elements. The Stream API is integrated into the Collections API, which enables bulk operations on collections, such as sequential or parallel map-reduce transformations.
  * Performance Improvement for HashMaps with Key Collisions
* Date-Time Package - a new set of packages that provide a comprehensive date-time model.
* java.lang and java.util Packages
  * Parallel Array Sorting
  * Standard Encoding and Decoding Base64
  * Unsigned Arithmetic Support
* Concurrency
  * Classes and interfaces have been added to the java.util.concurrent package.
  * Methods have been added to the java.util.concurrent.ConcurrentHashMap class to support aggregate operations based on the newly added streams facility and lambda expressions.
  * Classes have been added to the java.util.concurrent.atomic package to support scalable updatable variables.
  * Methods have been added to the java.util.concurrent.ForkJoinPool class to support a common pool.
  * The java.util.concurrent.locks.StampedLock class has been added to provide a capability-based lock with three modes for controlling read/write access.
* Hotspot
  * Removal of PermGen.

link:<https://www.oracle.com/java/technologies/javase/8-whats-new.html>

### 16 What's the difference between SpringBoot and SpringCloud ?

* springboot
  Spring Boot makes it easy to create stand-alone, production-grade Spring based Applications that you can "just run".
  We take an opinionated view of the Spring platform and third-party libraries so you can get started with minimum fuss. Most Spring Boot applications need minimal Spring configuration.
  If you’re looking for information about a specific version, or instructions about how to upgrade from an earlier release, check out the project release notes section on our wiki.

  **Features**
  * Create stand-alone Spring applications
  * Embed Tomcat, Jetty or Undertow directly (no need to deploy WAR files)
  * Provide opinionated 'starter' dependencies to simplify your build configuration
  * Automatically configure Spring and 3rd party libraries whenever possible
  * Provide production-ready features such as metrics, health checks, and externalized configuration
  * Absolutely no code generation and no requirement for XML configuration
* spring cloud
  Spring Cloud provides tools for developers to quickly build some of the common patterns in distributed systems (e.g. configuration management, service discovery, circuit breakers, intelligent routing, micro-proxy, control bus). Coordination of distributed systems leads to boiler plate patterns, and using Spring Cloud developers can quickly stand up services and applications that implement those patterns. They will work well in any distributed environment, including the developer’s own laptop, bare metal data centres, and managed platforms such as Cloud Foundry.
* the difference
  * SpringBoot focuses on the rapid and convenient development of individual microservices and SpringCloud focuses on the global service governance framework.
  * SpringCloud is a microservice coordination and management framework that focuses on the overall situation. It integrates and manages individual microservices developed by SpringBoot.
  * Provide integrated services between various microservices, such as configuration management, service discovery, circuit breakers, routing, microagents, event bus, global locks, decision-making campaigns, distributed conversations, etc.
  * SpringBoot can leave SpringCloud to use development projects independently, but SpringCloud cannot do without SpringBoot, which belongs to the relationship of dependency

### 17 What's the difference between SpringCloud and dubbo ?

* (1) The service calling method
  dubbo is RPC, springcloud Rest Api
* (2) Registration center
  dubbo is zookeeper and springcloud is eureka, or zookeeper
* (3) Service gateway
  * dubbo itself is not implemented, and can only be integrated through other third-party technologies.
  * Springcloud has Zuul routing gateway as a routing server for consumer request distribution. Springcloud supports circuit breakers and is perfectly integrated with git. Configuration file support version Control, transaction bus to achieve configuration file update and service automatic assembly, and a series of microservice architecture elements.

### 18 What is docker ?

  Docker is an open source containerization platform. It enables developers to package applications into containers—standardized executable components combining application source code with the operating system (OS) libraries and dependencies required to run that code in any environment. Containers simplify delivery of distributed applications, and have become increasingly popular as organizations shift to cloud-native development and hybrid multicloud environments.

  Developers can create containers without Docker, but the platform makes it easier, simpler, and safer to build, deploy and manage containers. Docker is essentially a toolkit that enables developers to build, deploy, run, update, and stop containers using simple commands and work-saving automation through a single API.
  
  A container is a standard unit of software that packages up code and all its dependencies so the application runs quickly and reliably from one computing environment to another. A Docker container image is a lightweight, standalone, executable package of software that includes everything needed to run an application: code, runtime, system tools, system libraries and settings.
  
  Container images become containers at runtime and in the case of Docker containers – images become containers when they run on Docker Engine. Available for both Linux and Windows-based applications, containerized software will always run the same, regardless of the infrastructure. Containers isolate software from its environment and ensure that it works uniformly despite differences for instance between development and staging.

### 19 What's the difference between containers and virtual Machines ?

  Containers and virtual machines have similar resource isolation and allocation benefits, but function differently because containers virtualize the operating system instead of hardware. Containers are more portable and efficient.

* containers
  Containers are an abstraction at the app layer that packages code and dependencies together. Multiple containers can run on the same machine and share the OS kernel with other containers, each running as isolated processes in user space. Containers take up less space than VMs (container images are typically tens of MBs in size), can handle more applications and require fewer VMs and Operating systems.
* virtual machines
  Virtual machines (VMs) are an abstraction of physical hardware turning one server into many servers. The hypervisor allows multiple VMs to run on a single machine. Each VM includes a full copy of an operating system, the application, necessary binaries and libraries – taking up tens of GBs. VMs can also be slow to boot.

### 20 Why use dubbo ?

  With the fast development of Internet, the scale of web applications expands unceasingly, and finally we find that the traditional vertical architecture(monolithic) can not handle this any more. Distributed service architecture and the flow computing architecture are imperative, and a governance system is urgently needed to ensure an orderly evolution of the architecture.

* Monolithic architecture
  When the traffic is very low, there is only one application, all the features are deployed together to reduce the deployment node and cost. At this point, the data access framework (ORM) is the key to simplifying the workload of the CRUD.
* Vertical architecture
  When the traffic gets heavier, add monolithic application instances can not accelerate the access very well, one way to improve efficiency is to split the monolithic into discrete applications. At this point, the Web framework (MVC) used to accelerate front-end page development is the key.
* Distributed service architecture
  When there are more and more vertical applications, the interaction between applications is inevitable, some core businesses are extracted and served as independent services, which gradually forms a stable service center，this way the front-end application can respond to the changeable market demand more quickly. At this point, the distributed service framework (RPC) for business reuse and integration is the key.
* Flow computing architecture
  When there are more and more services, capacity evaluation becomes difficult, and also services with small scales often causes waste of resources. To solve these problems, a scheduling center should be added to manage the cluster capacity based on traffics and to improve the utilization of the cluster. At this time, the resource scheduling and governance centers (SOA), which are used to improve machine utilization, are the keys.

### 21 Tell me about your project

* closed-end and open-end
  Basically, there are two ways to borrow money: closed-end credit and open-end credit. A loan is an example of closed-end credit. When applying for a loan, you and the bank agree on the exact amount of money you will borrow, the exact amount of time you'll have to pay it back and at what interest rate you'll be charged. These are called the terms of the loan. A loan is called closed-end credit because there's a set date when all of the debt needs to be paid back in full, plus interest.
* loan: closed-end credit
  A loan is typically repaid through fixed monthly payments. Each monthly payment includes both principal and interest. A mortgage is a good example of a closed-end loan. If you take out a 30-year mortgage for \$100,000 at an annual interest rate of 8 percent, your monthly mortgage payment would be \$733.76. After 30 years, you would have paid back the entire \$100,000 plus interest (\$164,153).
* my project
  I will introduce the credit loan system to you. The credit Loan system is a distributed service system, it consists of several subsystems, such as APS, CPS, PFS, CTS, SMS etc. I am in charge of 3 of them: CTS, means collect system, PFS means Pay Front system, SMS means short message system.
  * Two processes
    * Loan Process
    a customer who wants to apply for a loan must submit personal information including name, gender, ID CARD number, mobile phone number, address, emergency contact, income certificate and other information, and will sign some protocols. This information comes to audit system APS, which will check the customer's credit and the ability to pay back the money. If application approved, the request comes to core system CPS, the customer's information will be saved into database, a request for loan would be sent to PFS, PFS will check the parameter and pass it to next node to loan money then return the loan result to CPS. If CPS receives successful message from PFS, it will generate repayment schedule. The customer borrow money successfully.
    * Collect Process
    There are two ways to collect, automatic collection of PFS and manual collection of CTS. PFS will collect automatically using several schedule tasks, if this failed, it's time for CTS to collect manually. When the due time to repay the money comes, CPS will transfer customer's information to CTS and PFS in the morning. If the customer fail to repay before 18:00, PFS will collect money from customer's bank card, if successfully, PFS will send mq message to CPS, CPS will record this, and update the customer's account information, then CPS send message to CTS and PFS noticing that this customer has repaid this amount of money back, CTS and PFS will update the customer's account information immediately. If there is no enough money in customer's bank card, collection by PFS failed to collect the money, PFS will not send message to CPS. So CPS marks this customer's account status as overdue. Every morning, CPS transfers this customer's account information with other customers' account of overdue status to CTS and PFS, CTS will create a case of the customer, CTS and PFS keep collecting until the customer repay all money back. If the customer repay all money back, the case will be canceled.

### 22 What's kubernetes ?

* Kubernetes, also known as K8s, is an open-source system for automating deployment, scaling, and management of containerized applications.
* Kubernetes is a portable, extensible, open source platform for managing containerized workloads and services, that facilitates both declarative configuration and automation. It has a large, rapidly growing ecosystem. Kubernetes services, support, and tools are widely available.

* Traditional deployment era: Early on, organizations ran applications on physical servers. There was no way to define resource boundaries for applications in a physical server, and this caused resource allocation issues. For example, if multiple applications run on a physical server, there can be instances where one application would take up most of the resources, and as a result, the other applications would underperform. A solution for this would be to run each application on a different physical server. But this did not scale as resources were underutilized, and it was expensive for organizations to maintain many physical servers.

* Virtualized deployment era: As a solution, virtualization was introduced. It allows you to run multiple Virtual Machines (VMs) on a single physical server's CPU. Virtualization allows applications to be isolated between VMs and provides a level of security as the information of one application cannot be freely accessed by another application.

  Virtualization allows better utilization of resources in a physical server and allows better scalability because an application can be added or updated easily, reduces hardware costs, and much more. With virtualization you can present a set of physical resources as a cluster of disposable virtual machines.

  Each VM is a full machine running all the components, including its own operating system, on top of the virtualized hardware.

* Container deployment era: Containers are similar to VMs, but they have relaxed isolation properties to share the Operating System (OS) among the applications. Therefore, containers are considered lightweight. Similar to a VM, a container has its own filesystem, share of CPU, memory, process space, and more. As they are decoupled from the underlying infrastructure, they are portable across clouds and OS distributions.

  Containers have become popular because they provide extra benefits, such as:
  * Agile application creation and deployment: increased ease and efficiency of container image creation compared to VM image use.
  * Continuous development, integration, and deployment: provides for reliable and frequent container image build and deployment with quick and efficient rollbacks (due to image immutability).
  * Dev and Ops separation of concerns: create application container images at build/release time rather than deployment time, thereby decoupling applications from infrastructure.
  * Observability: not only surfaces OS-level information and metrics, but also application health and other signals.
  * Environmental consistency across development, testing, and production: Runs the same on a laptop as it does in the cloud.
  * Cloud and OS distribution portability: Runs on Ubuntu, RHEL, CoreOS, on-premises, on major public clouds, and anywhere else.
  * Application-centric management: Raises the level of abstraction from running an OS on virtual hardware to running an application on an OS using logical resources.
  * Loosely coupled, distributed, elastic, liberated micro-services: applications are broken into smaller, independent pieces and can be deployed and managed dynamically – not a monolithic stack running on one big single-purpose machine.
  * Resource isolation: predictable application performance.
  * Resource utilization: high efficiency and density.
