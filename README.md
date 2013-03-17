# 虾米酱 - XiamiSauce

[![Gem Version](https://badge.fury.io/rb/xiami_sauce.png)](http://badge.fury.io/rb/xiami_sauce)
[![Build Status](https://travis-ci.org/ranmocy/xiami_sauce.png)](https://travis-ci.org/ranmocy/xiami_sauce)
[![Dependency Status](https://gemnasium.com/ranmocy/xiami_sauce.png)](https://gemnasium.com/ranmocy/xiami_sauce)
[![Code Climate](https://codeclimate.com/github/ranmocy/xiami_sauce.png)](https://codeclimate.com/github/ranmocy/xiami_sauce)

虾米酱是一个虾米音乐下载器。封装成为一个 Ruby Gem 包。

XiamiSauce is a downloader of Xiami Music. Writed in Ruby, and presented as a Gem.

## Why

You know, if you know it.

## 依赖 - Dependency

虾米酱在 Ruby 1.9.2, 1.9.3, 2.0.0, jRuby, REE 环境下测试。
XiamiSauce will be tested under Ruby 1.9.2, 1.9.3, 2.0.0, jRuby, REE.

依赖 Thor, Nokogiri 的 Gem 包。
Depend on Gems Thor and Nokogiri.

## 安装 - Installation

一句话安装 - Install it with one-line code:

    $ gem install xiami_sauce --no-ri --no-doc

## 使用方法 - Usage

    $ xsauce http://www.xiami.com/artist/64360
    $ xsauce http://www.xiami.com/album/355791
    $ xsauce http://www.xiami.com/song/184616

虾米酱会按照歌曲信息下载到 `[artist]/[album]/[index].[song].mp3`。

XiamiSauce will download to `[artist]/[album]/[index].[song].mp3`.

## 参与 - Contributing

1. 派生 - Fork it
2. 新建特性分支 - Create your feature branch (`git checkout -b my-new-feature`)
3. 提交你的修改 - Commit your changes (`git commit -am 'Add some feature'`)
4. 推送特性分支 - Push to the branch (`git push origin my-new-feature`)
5. 发起合并请求 - Create new Pull Request
