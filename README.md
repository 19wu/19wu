## 19wu
[![Build Status](https://travis-ci.org/saberma/19wu.png?branch=master)](https://travis-ci.org/saberma/19wu) [![Code Climate](https://codeclimate.com/github/saberma/19wu.png)](https://codeclimate.com/github/saberma/19wu) [![Dependency Status](https://gemnasium.com/saberma/19wu.png)](https://gemnasium.com/saberma/19wu) [![Coverage Status](https://coveralls.io/repos/saberma/19wu/badge.png?branch=master)](https://coveralls.io/r/saberma/19wu)

这里是 [19wu.com](http://19wu.com) 网站源代码.

## 官网

http://19wu.com/szruby

部署在 Heroku 的测试网站

http://saberma-19wu.herokuapp.com
Email：`demo@19wu.com`
Password：`666666`

## 系统要求

* Ruby 2.0.0 (or 1.9.3)
* PostgreSQL (or MySQL, SQLite)

## 安装步骤

```bash
git clone git://github.com/saberma/19wu.git
cd 19wu
bundle install --without sqlite3 mysql2
rake setup
rails server
```

[详情](https://github.com/saberma/19wu/issues/19)

## 文档资源

[Wiki文档](https://github.com/saberma/19wu/wiki)

[常见问题](https://github.com/saberma/19wu/wiki/%E6%96%B0%E6%89%8B%E9%97%AE%E9%A2%98%E6%B1%87%E6%80%BB)

## 变更记录

* 06-22 [#380](https://github.com/saberma/19wu/pull/380) 主办者可以复制以前的活动信息 [@saberma](https://github.com/saberma)
* 06-19 [#378](https://github.com/saberma/19wu/pull/378) 主办者可以发送临时变更通知 [@saberma](https://github.com/saberma)
* 06-07 [#375](https://github.com/saberma/19wu/pull/375) 提升 Travis-CI 的测试效率 [@saberma](https://github.com/saberma)
* 06-05 [#373](https://github.com/saberma/19wu/pull/373) 活动信息导出为 Markdown 格式 [@ywjno](https://github.com/ywjno)
* 06-03 [#369](https://github.com/saberma/19wu/pull/369) 参与者可以通过二维码进行签到 [@loveky](https://github.com/loveky)
* 05-29 [#366](https://github.com/saberma/19wu/pull/366) 主办人可以活动管理协办者 [@saberma](https://github.com/saberma)
* 05-27 [#365](https://github.com/saberma/19wu/pull/365) 管理员可以填写活动总结 [@loveky](https://github.com/loveky)
* 05-24 [#363](https://github.com/saberma/19wu/pull/363) 根据地址显示百度地图 [@loveky](https://github.com/loveky)
* 05-23 [#361](https://github.com/saberma/19wu/pull/361) 签到页面由列表布局改为网格布局 [@ywjno](https://github.com/ywjno)
* 05-23 [#360](https://github.com/saberma/19wu/pull/360) 显示活动管理菜单，引入 tabs_on_rails [@saberma](https://github.com/saberma)
* 05-21 [#354](https://github.com/saberma/19wu/pull/354) 显示关注者列表 [@ebowsoft](https://github.com/ebowsoft)
* 05-19 [#351](https://github.com/saberma/19wu/pull/351) 显示往期活动记录 [@loveky ](https://github.com/loveky )
* 05-16 [#344](https://github.com/saberma/19wu/pull/344) 使用 SendGrid 发送邮件 [@saberma](https://github.com/saberma)
* 05-14 [#342](https://github.com/saberma/19wu/pull/342) 修正游客注册后未能跳转到活动页面的问题 [@saberma](https://github.com/saberma)
* 05-10 [#335](https://github.com/saberma/19wu/pull/335) 更新首页功能特色的图片描述 [@saberma](https://github.com/saberma)
* 05-09 [#334](https://github.com/saberma/19wu/pull/334) 报名按钮在活动结束显示为'已结束' [@ebowsoft](https://github.com/ebowsoft)
* 05-02 [#329](https://github.com/saberma/19wu/pull/329) 报名后直接更新已参加用户 [@saberma](https://github.com/saberma)

[所有变更记录](CHANGELOG.md)

## 团队

* [@saberma](https://github.com/saberma)
* [@doitian](https://github.com/doitian)
* [@lgn21st](https://github.com/lgn21st)
* [@windy](https://github.com/windy)

[所有贡献者](https://github.com/saberma/19wu/graphs/contributors)

## 赞助商

感谢以下赞助商：

* [推立方](http://tui3.com/) 短信赞助商

## License

[The MIT License](https://github.com/saberma/19wu/blob/master/LICENSE)

Project is a member of the [OSS Manifesto](http://ossmanifesto.org).
