# 19wu

19wu - 卖活动票的小屋

有兴趣参与的同学，请点击 [这里](https://github.com/saberma/19wu/issues/2) 留名
有兴趣加入核心研发团队的请在 [这里](https://github.com/saberma/19wu/issues/9) 申请

### 项目是做什么的？

有些线下活动（e.g.RubyConfChina）需要卖票，19wu 就是一个卖票的电子商务平台。

### 利用 ShopQi 也能卖票，为什么要重新做？

[ShopQi](http://github.com/saberma/shopqi) 是一个商品网上交易平台，而票务平台的购买流程会简单一些，但需要更多的细化功能，如生成电子票、签到等，重新开始一个专门的项目比在 ShopQi 的基础上修改更合适一些。

### 已经有其他售票平台了，这个有什么差异的地方？

最主要差异是完全开源免费，另外可以提供代卖公司票的服务（提供发票并快递给顾客）。

### 为什么开源？

最好的产品是自己会去用的产品，最好的开源项目也是如此。比如说论坛，业务简单、容易理解，所以开源出来，大家可以边用边完善，可以提供很好的交流提升机会。

而售票平台可以算是较简单的电子商务项目，容易上手，很适合开源出来，参与门槛也不高。

### 现在一点代码都没有？

是的，之前做 ShopQi 时，项目功能太多，后期不少朋友想要贡献代码非常困难。

所以这个项目，我觉得可以不急着写代码，先推迟 2 周，欢迎大家参与，我将于 **12月24日** 开始开发，并持续利用业余时间进行完善。

### 免费的线下活动可以用这个吗？

可以的，只要把票价设置为0，就是免费活动了，通过 19wu 可以进行签到、统计等操作。

## 技术选型

一个约定：代码不超过 **2000** 行

* Rails 3
* 数据库使用 PostgreSQL
* 后台任务使用 delayed_job，而不使用 resque，避免对 redis 的依赖
* 前端基于 [Bootstrap](http://twitter.github.com/bootstrap) 和 [Spine.js](http://spinejs.com)

## 开发计划

开发时会针对一个个小的功能点提出 issue，提交的代码要与相应 issue 关联。

### Week #1

做出最小可用原型，不涉及支付流程等。

* 主办方用户注册、发起免费活动
* 普通用户报名参加
* 主办方用户查看参与者用户列表

域名备案通过即上线内部试用。

### Week #2

加入签到功能，先只支持二三十人左右的小型会议，不涉及电子票码生成。

* 参与者用户到达会场后，由主办方用户直接勾选签到

### Week #3

支持手机访问。

* 参与者用户查看活动时间、地点
* 参与者用户查看参与者列表（独立列表，带头像），对其他参与者有个基本了解。


以上为初步计划，待进一步讨论细化。

## 团队

### 管理团队

* [马海波 @saberma](https://github.com/saberma)
* [吕国宁 @lgn21st](https://github.com/lgn21st)
* [李亚飞 @windy](https://github.com/windy)

### 贡献者

[所有贡献者](https://github.com/saberma/19wu/graphs/contributors)

* 持续招募中。。。
* 加入条件：无，只要你有时间参与就行

### 如何参与

* 在 [Issue](https://github.com/saberma/19wu/issues) 发起讨论
* 对提交的代码有任何疑问时发起讨论
* 开发一些功能（需要带测试，以保证此功能在后续开发时不被破坏）
* 试用已有的功能，提出建议
* 向身边的朋友介绍 19wu

[更多...](https://github.com/saberma/19wu/blob/master/CONTRIBUTING.md)

## License

[The MIT License](https://github.com/saberma/19wu/blob/master/LICENSE)
