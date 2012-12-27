# 添加新功能

所有功能会使用 [Github Issues](https://github.com/saberma/19wu/issues) 追踪和讨
论。如果有新功能的建议，也可以
[建立新的 Issue](https://github.com/saberma/19wu/issues/new)，使用标题简要描述
要做什么，并在正文中补充详细信息方便大家讨论。

代码贡献采用 Pull Request，如果还不熟悉流程，可以参考 Wiki
[如何贡献代码](https://github.com/saberma/19wu/wiki/如何贡献代码) 和
[#41](https://github.com/saberma/19wu/issues/41) 中的讨论。请在提交的 Pull
Request 中使用 `#id` 提及相关的 Issues。

Pull Request 中的代码更改需要测试代码覆盖，以保证这些更改在后续时不被破坏。测试分成三部分。

-   集成测试。基于 rspec 和 [capybara](https://github.com/jnicklas/capybara)。详
    细参考 capistrano 的文档。测试文件放到 spec/features 下。通过 `rspec
    spec/features` 运行。
-   单元测试，使用 rspec。通过 `rake rspec` 运行（也会运行集成测试）。
-   Javascript 测试，使用 [jasmine](http://pivotal.github.com/jasmine/)。测试文件
    放到 spec/javascripts 下。通过 `rake jasmine:ci` 运行。

新功能，改变网站行为，或者对后续开发有影响的改动需要在 Pull Request 中更新
[CHANGELOG](https://github.com/saberma/19wu/blob/master/CHANGELOG.md)。

有任何问题都可以在 Issues 中提出。

# Bug 报告和修复

你可以通过在本地部署或者访问 http://19wu.com 来试用功能，通过 Github Issues
[提交](https://github.com/saberma/19wu/issues/new) 建议或者找到的 Bug。为了方便
快速确认和定位，Bug 应该有详细的环境描述和重现步骤。可以参考
[已经提交](https://github.com/saberma/19wu/issues?labels=bug&page=1&state=closed)
的 Bugs ，或者使用下面的模板:

    注册成功后无法登录
    
    - 版本：0.0.1
    - 浏览器：Google Chrome 23
    - 操作系统：Linux
    
    重现步骤：
    
    -  在首页注册新用户。
    -  成功后使用用户名和密码登录。
    -  提示用户不存在，无法登录。见截图。

Bug 修复同样使用 Pull Request 贡献，并在
[CHANGELOG](https://github.com/saberma/19wu/blob/master/CHANGELOG.md) 中记录。

# 翻译

-   可以参考[如何贡献代码](https://github.com/saberma/19wu/wiki/如何贡献代码)，翻
    译 config/locales 下的文件并提交 Pull Request。

-   也可以在线浏览 [config/locales](https://github.com/saberma/19wu/tree/master/config/locales)
    并把翻译的文件通过 Issue 提交。

# 文档

社区通过 [Wiki](https://github.com/saberma/19wu/wiki) 维护各种文档。也可以在
[Issues](https://github.com/saberma/19wu/issues) 中搜索以前的讨论。

Wiki 目录是开放编辑的，欢迎更正错误，并添加新的内容。

# 宣传

-   向身边的朋友介绍 19wu
-   通过博客，微博介绍
-   使用 19wu 发起活动
