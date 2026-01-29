window.__require = function e(t, o, n) {
    function i(a, s) {
        if (!o[a]) {
            if (!t[a]) {
                var c = a.split("/");
                if (c = c[c.length - 1],
                !t[c]) {
                    var l = "function" == typeof __require && __require;
                    if (!s && l)
                        return l(c, !0);
                    if (r)
                        return r(c, !0);
                    throw new Error("Cannot find module '" + a + "'")
                }
                a = c
            }
            var f = o[a] = {
                exports: {}
            };
            t[a][0].call(f.exports, function(e) {
                return i(t[a][1][e] || e)
            }, f, f.exports, e, t, o, n)
        }
        return o[a].exports
    }
    for (var r = "function" == typeof __require && __require, a = 0; a < n.length; a++)
        i(n[a]);
    return i
}({
    AdvertUI: [function(e, t, o) {
        "use strict";
        cc._RF.push(t, "d5f10qs+OBKMZd2W7hkz7s7", "AdvertUI");
        var n, i = this && this.__extends || (n = function(e, t) {
            return (n = Object.setPrototypeOf || {
                __proto__: []
            }instanceof Array && function(e, t) {
                e.__proto__ = t
            }
            || function(e, t) {
                for (var o in t)
                    Object.prototype.hasOwnProperty.call(t, o) && (e[o] = t[o])
            }
            )(e, t)
        }
        ,
        function(e, t) {
            function o() {
                this.constructor = e
            }
            n(e, t),
            e.prototype = null === t ? Object.create(t) : (o.prototype = t.prototype,
            new o)
        }
        );
        Object.defineProperty(o, "__esModule", {
            value: !0
        }),
        o.AdvertUI = void 0;
        var r = e("../../base/common/MessageMgr")
          , a = e("../../base/common/SpecialFunc")
          , s = e("../config/Config")
          , c = e("../../base/SoundMgr")
          , l = e("../../base/common/view/PageView")
          , f = e("../../base/res/DyncLoadedBase")
          , h = e("../../base/res/DyncMgr")
          , d = e("../../base/res/LanguageMgr")
          , u = e("../../base/LogicMgr")
          , p = function(e) {
            function t() {
                var t = null !== e && e.apply(this, arguments) || this;
                return t._guanggao = [],
                t
            }
            return i(t, e),
            t.prototype.resetParams = function(e) {
                this._adRoot = e,
                u.default.login.succeed ? this.loginSucceeded() : r.MessageMgr.once(r.MessageName.LoginSucceeded, this.loginSucceeded, this)
            }
            ,
            t.prototype.loginSucceeded = function() {
                var e, t = this;
                this._adRoot.getComponent(cc.PageView).removeAllPages();
                for (var o = [], n = function(e) {
                    var n = cc.instantiate(i.nodeInfo.root);
                    o.push(n),
                    n.on(u.ConstDefine.click, function() {
                        t.pgClick(e)
                    })
                }, i = this, a = 0; a < u.default.login.guangGao.length; a++)
                    n(a);
                this.nodeInfo.root.active = !1;
                var s = {
                    root: this._adRoot,
                    contents: o,
                    audoPlay: !0,
                    toggleName: "singleToggleB"
                };
                if (this._loopPgView = new l.LoopTogglePageView(s),
                (e = this._guanggao).push.apply(e, u.default.login.guangGao),
                this._guanggao.length > 1) {
                    var c = this._guanggao[0]
                      , f = this._guanggao[this._guanggao.length - 1];
                    this._guanggao.unshift(f),
                    this._guanggao.push(c)
                }
                r.MessageMgr.on(r.MessageName.ChangeLang, this.changeLang, this),
                this.changeLang()
            }
            ,
            t.prototype.pgClick = function(e) {
                c.default.playEffect(u.ConstDefine.click),
                h.default.getResInfo("bigAdvertUI", e)
            }
            ,
            t.prototype.changeLang = function() {
                for (var e = s.Config.configPath + "lang/" + d.default.currLang + "/advert/", t = e + "tag/", o = 0; o < this._guanggao.length; o++) {
                    var n = this._loopPgView.contents[o]
                      , i = this._guanggao[o]
                      , r = n.getChildByName(u.ConstDefine.Background).getComponent(cc.Sprite);
                    a.default.setRemoteSpt(e, u.ConstDefine.ad, i, r);
                    var c = u.default.kpKeyCfg[i];
                    if (c && void 0 !== c.t) {
                        var l = n.getChildByName("tag").getComponent(cc.Sprite);
                        a.default.setRemoteSpt(t, u.ConstDefine.tag, c.t, l)
                    }
                }
            }
            ,
            t
        }(f.default);
        o.AdvertUI = p,
        cc._RF.pop()
    }
    , {
        "../../base/LogicMgr": "LogicMgr",
        "../../base/SoundMgr": "SoundMgr",
        "../../base/common/MessageMgr": "MessageMgr",
        "../../base/common/SpecialFunc": "SpecialFunc",
        "../../base/common/view/PageView": "PageView",
        "../../base/res/DyncLoadedBase": "DyncLoadedBase",
        "../../base/res/DyncMgr": "DyncMgr",
        "../../base/res/LanguageMgr": "LanguageMgr",
        "../config/Config": "Config"
    }],
    BigAdvertUI: [function(e, t, o) {
        "use strict";
        cc._RF.push(t, "23bf9jq1hJI2Lw1HidDp8d/", "BigAdvertUI");
        var n, i = this && this.__extends || (n = function(e, t) {
            return (n = Object.setPrototypeOf || {
                __proto__: []
            }instanceof Array && function(e, t) {
                e.__proto__ = t
            }
            || function(e, t) {
                for (var o in t)
                    Object.prototype.hasOwnProperty.call(t, o) && (e[o] = t[o])
            }
            )(e, t)
        }
        ,
        function(e, t) {
            function o() {
                this.constructor = e
            }
            n(e, t),
            e.prototype = null === t ? Object.create(t) : (o.prototype = t.prototype,
            new o)
        }
        );
        Object.defineProperty(o, "__esModule", {
            value: !0
        });
        var r = e("../../base/common/view/PageView")
          , a = e("../../base/common/SpecialFunc")
          , s = e("../config/Config")
          , c = e("../../base/net/GameNet")
          , l = e("../../base/SoundMgr")
          , f = e("../../base/common/view/Tip")
          , h = e("../../base/common/Interface")
          , d = e("../../base/LogicMgr")
          , u = function(e) {
            function t() {
                return null !== e && e.apply(this, arguments) || this
            }
            return i(t, e),
            t.prototype.initParams = function() {
                var t = this;
                e.prototype.initParams.call(this),
                this._popupMethod.root.getChildByName(d.ConstDefine.close).on(d.ConstDefine.click, this.close, this);
                var o = this._popupMethod.root.getChildByName("offsetX")
                  , n = o.getChildByName("title");
                this._titleChildren = n.children;
                for (var i = 0, r = this._titleChildren; i < r.length; i++) {
                    var c = r[i];
                    c.opacity = 0,
                    c.active = !0
                }
                this._playNow = o.getChildByName("playNow"),
                this._playNow.active = !1,
                this._playNow.on(d.ConstDefine.click, this.playNowClick.bind(this)),
                this._pgNode = o.getChildByName("pageView");
                for (var l = this._pgNode.getComponent(cc.PageView), f = this._pgNode.getChildByName("prefab"), h = 0; h < d.default.login.guangGao.length; h++) {
                    var u = d.default.login.guangGao[h]
                      , p = cc.instantiate(f);
                    l.addPage(p),
                    a.default.setRemoteSpt(s.Config.configPath + "bigAdvertUI/", d.ConstDefine.bad, u, p.getComponent(cc.Sprite))
                }
                f.destroy(),
                this.showInfo(0),
                this.nodeInfo.root.getChildByName("wheel").on(cc.Node.EventType.MOUSE_WHEEL, function(e) {
                    a.default.onMouseWheel(e.getScrollY(), t._togglePageView)
                })
            }
            ,
            t.prototype.resetParams = function(t) {
                if (e.prototype.resetParams.call(this),
                ++t,
                this._togglePageView)
                    this._nodeInfo.root.active = !0,
                    this._togglePageView.toggleRoll(t, !1);
                else {
                    var o = {
                        root: this._pgNode,
                        finishCall: function(e) {
                            e.toggleRoll(t, !1);
                            var o = e.pgView.content.children
                              , n = o[0]
                              , i = o[o.length - 1];
                            a.default.setRemoteSpt(s.Config.configPath + "bigAdvertUI/", d.ConstDefine.bad, d.default.login.guangGao[d.default.login.guangGao.length - 1], n.getComponent(cc.Sprite)),
                            a.default.setRemoteSpt(s.Config.configPath + "bigAdvertUI/", d.ConstDefine.bad, d.default.login.guangGao[0], i.getComponent(cc.Sprite))
                        },
                        pgChangeCall: this.showInfo.bind(this)
                    };
                    this._togglePageView = new r.LoopTogglePageView(o)
                }
            }
            ,
            t.prototype.showInfo = function(e) {
                if (this._lastIndex !== e) {
                    this._lastShowTitle && (this._lastShowTitle.opacity = 0),
                    this._lastIndex = e;
                    var t = this.getKpCfg();
                    void 0 !== t ? void 0 !== t.t ? (this._lastShowTitle = this._titleChildren[t.t],
                    this._lastShowTitle.opacity = 255,
                    t.t !== h.GameTag.comingSoon ? this._playNow.active = !0 : this._playNow.active = !1) : (this._lastShowTitle = null,
                    this._playNow.active = !0) : (this._lastShowTitle = null,
                    this._playNow.active = !1)
                }
            }
            ,
            t.prototype.playNowClick = function() {
                l.default.playEffect(d.ConstDefine.click),
                c.default.startGame(this.getKpCfg())
            }
            ,
            t.prototype.getKpCfg = function() {
                var e = d.default.login.guangGao[this._lastIndex]
                  , t = d.default.kpKeyCfg[e];
                return void 0 === t && (t = d.default.bigGG[e]),
                t
            }
            ,
            t
        }(f.PopupBase);
        o.default = u,
        cc._RF.pop()
    }
    , {
        "../../base/LogicMgr": "LogicMgr",
        "../../base/SoundMgr": "SoundMgr",
        "../../base/common/Interface": "Interface",
        "../../base/common/SpecialFunc": "SpecialFunc",
        "../../base/common/view/PageView": "PageView",
        "../../base/common/view/Tip": "Tip",
        "../../base/net/GameNet": "GameNet",
        "../config/Config": "Config"
    }],
    BsLangText: [function(e, t, o) {
        "use strict";
        cc._RF.push(t, "b72d2wMmcdGc7IfnOnIO3Eb", "BsLangText"),
        Object.defineProperty(o, "__esModule", {
            value: !0
        }),
        o.default = {
            ch: ["", "\u62b1\u6b49\u5730\u901a\u77e5\u60a8\uff0c\u7cfb\u7edf\u7981\u6b62\u4e86\u60a8\u6240\u5728\u7684 IP \u5730\u5740\u7684\u767b\u5f55\u529f\u80fd\uff0c\u8bf7\u8054\u7cfb\u5ba2\u6237\u670d\u52a1\u4e2d\u5fc3\u4e86\u89e3\u8be6\u7ec6\u60c5\u51b5\uff01", "\u62b1\u6b49\u5730\u901a\u77e5\u60a8\uff0c\u7cfb\u7edf\u7981\u6b62\u4e86\u60a8\u7684\u673a\u5668\u7684\u767b\u5f55\u529f\u80fd\uff0c\u8bf7\u8054\u7cfb\u5ba2\u6237\u670d\u52a1\u4e2d\u5fc3\u4e86\u89e3\u8be6\u7ec6\u60c5\u51b5\uff01", "\u60a8\u7684\u5e10\u53f7\u4e0d\u5b58\u5728\u6216\u8005\u5bc6\u7801\u8f93\u5165\u6709\u8bef\uff0c\u8bf7\u67e5\u8bc1\u540e\u518d\u6b21\u5c1d\u8bd5\u767b\u5f55\uff01", "\u60a8\u7684\u5e10\u53f7\u6682\u65f6\u5904\u4e8e\u51bb\u7ed3\u72b6\u6001\uff0c\u8bf7\u8054\u7cfb\u5ba2\u6237\u670d\u52a1\u4e2d\u5fc3\u4e86\u89e3\u8be6\u7ec6\u60c5\u51b5\uff01", "\u60a8\u7684\u5e10\u53f7\u4f7f\u7528\u4e86\u5b89\u5168\u5173\u95ed\u529f\u80fd\uff0c\u5fc5\u987b\u91cd\u65b0\u5f00\u901a\u540e\u624d\u80fd\u7ee7\u7eed\u4f7f\u7528\uff01", "\u60a8\u7684\u5e10\u53f7\u4f7f\u7528\u56fa\u5b9a\u673a\u5668\u767b\u5f55\u529f\u80fd\uff0c\u60a8\u73b0\u6240\u4f7f\u7528\u7684\u673a\u5668\u4e0d\u662f\u6240\u6307\u5b9a\u7684\u673a\u5668\uff01", "\u60a8\u7684\u5e10\u53f7\u4e0d\u5b58\u5728\u6216\u8005\u5bc6\u7801\u8f93\u5165\u6709\u8bef\uff0c\u8bf7\u67e5\u8bc1\u540e\u518d\u6b21\u5c1d\u8bd5\u767b\u5f55\uff01", "\u7528\u6237\u4fe1\u606f\u4e0d\u5b58\u5728\uff0c\u673a\u5668\u7ed1\u5b9a\u5931\u8d25\uff01", "\u673a\u5668\u7ed1\u5b9a\u5931\u8d25\uff0c\u672a\u77e5\u9519\u8bef!", "\u60a8\u7684\u5e10\u53f7\u5df2\u7ecf\u7ed1\u5b9a\u4e86\u5176\u4ed6\u673a\u5668\u4e86\uff0c\u5fc5\u987b\u89e3\u9664\u540e\u624d\u80fd\u8fdb\u884c\u672c\u673a\u7ed1\u5b9a\u64cd\u4f5c\uff01", "\u673a\u5668\u7ed1\u5b9a\u5931\u8d25\uff0c\u672a\u77e5\u9519\u8bef!", "\u5e10\u53f7\u7ed1\u5b9a\u64cd\u4f5c\u6267\u884c\u9519\u8bef\uff0c\u8bf7\u8054\u7cfb\u5ba2\u6237\u670d\u52a1\u4e2d\u5fc3\uff01", "\u60a8\u7684\u5e10\u53f7\u4e0e\u6b64\u673a\u5668\u7ed1\u5b9a\u6210\u529f\u4e86\uff0c\u82e5\u9700\u8981\u89e3\u9664\u7ed1\u5b9a\u9700\u5728\u672c\u673a\u5668\u8fdb\u884c\uff01 ", "\u7528\u6237\u4fe1\u606f\u4e0d\u5b58\u5728\uff0c\u673a\u5668\u7ed1\u5b9a\u5931\u8d25\uff01", "\u60a8\u7684\u5e10\u53f7\u4e0e\u5176\u4ed6\u673a\u5668\u8fdb\u884c\u4e86\u7ed1\u5b9a\uff0c\u673a\u5668\u89e3\u9664\u7ed1\u5b9a\u5931\u8d25\uff01", "\u672a\u77e5\u9519\u8bef\uff0c\u673a\u5668\u89e3\u9664\u7ed1\u5b9a\u5931\u8d25\uff01", "\u5e10\u53f7\u89e3\u9664\u7ed1\u5b9a\u64cd\u4f5c\u6267\u884c\u9519\u8bef\uff0c\u8bf7\u8054\u7cfb\u5ba2\u6237\u670d\u52a1\u4e2d\u5fc3\uff01", "\u60a8\u7684\u5e10\u53f7\u4e0e\u673a\u5668\u89e3\u9664\u7ed1\u5b9a\u6210\u529f\u4e86\uff01 ", "\u62b1\u6b49\u5730\u901a\u77e5\u60a8\uff0c\u7cfb\u7edf\u7981\u6b62\u4e86\u60a8\u6240\u5728\u7684 IP \u5730\u5740\u7684\u6e38\u620f\u767b\u5f55\u6743\u9650\uff0c\u8bf7\u8054\u7cfb\u5ba2\u6237\u670d\u52a1\u4e2d\u5fc3\u4e86\u89e3\u8be6\u7ec6\u60c5\u51b5\uff01", "\u60a8\u7684\u5e10\u53f7\u4e0d\u5b58\u5728\u6216\u8005\u5bc6\u7801\u8f93\u5165\u6709\u8bef\uff0c\u8bf7\u67e5\u8bc1\u540e\u518d\u6b21\u5c1d\u8bd5\u767b\u5f55\uff01", "\u60a8\u7684\u5e10\u53f7\u6682\u65f6\u5904\u4e8e\u51bb\u7ed3\u72b6\u6001\uff0c\u8bf7\u8054\u7cfb\u5ba2\u6237\u670d\u52a1\u4e2d\u5fc3\u4e86\u89e3\u8be6\u7ec6\u60c5\u51b5\uff01", "\u60a8\u7684\u5e10\u53f7\u4f7f\u7528\u4e86\u5b89\u5168\u5173\u95ed\u529f\u80fd\uff0c\u5fc5\u987b\u91cd\u65b0\u5f00\u901a\u540e\u624d\u80fd\u7ee7\u7eed\u4f7f\u7528\uff01", "\u60a8\u7684\u5e10\u53f7\u4f7f\u7528\u56fa\u5b9a\u673a\u5668\u767b\u5f55\u529f\u80fd\uff0c\u60a8\u73b0\u6240\u4f7f\u7528\u7684\u673a\u5668\u4e0d\u662f\u6240\u6307\u5b9a\u7684\u673a\u5668\uff01", "\u62b1\u6b49,\u7531\u4e8e\u60a8\u7684\u5e10\u53f7\u5728\u5176\u5b83\u5730\u65b9\u767b\u5f55,\u8bf7\u91cd\u65b0\u767b\u5f55\u5e73\u53f0\u540e\u518d\u6b21\u5c1d\u8bd5\uff01", "\u62b1\u6b49\u5730\u901a\u77e5\u4f60\uff0c\u60a8\u7684\u6e38\u620f\u5e01\u6570\u636e\u51fa\u73b0\u4e86\u5f02\u5e38\u60c5\u51b5\uff0c\u8bf7\u8054\u7cfb\u5ba2\u6237\u670d\u52a1\u4e2d\u5fc3\u4e86\u89e3\u8be6\u7ec6\u60c5\u51b5\uff01", "\u62b1\u6b49,\u60a8\u6b63\u5728\u6e38\u620f\u623f\u95f4\u4e2d\uff0c\u4e0d\u80fd\u540c\u65f6\u518d\u8fdb\u5165\u6b64\u6e38\u620f\u623f\u95f4\uff01", "\u62b1\u6b49\uff0c\u7cfb\u7edf\u68c0\u6d4b\u5230\u60a8\u7684\u8d26\u53f7\u6b63\u5904\u4e8e\u6e38\u620f\u5f53\u4e2d\uff0c\u7981\u6b62\u8fdb\u5165\u6e38\u620f\u623f\u95f4\uff01", "\u5e10\u53f7\u5bc6\u7801\u4fee\u6539\u6210\u529f\uff0c\u8bf7\u7262\u8bb0\u60a8\u7684\u65b0\u5e10\u53f7\u5bc6\u7801", "\u6b64\u8d26\u53f7\u5f02\u5730\u5c1d\u8bd5\u767b\u5165\uff0c\u8bf7\u66f4\u6539\u5bc6\u7801.", "\u6b64\u8d26\u53f7\u5df2\u5728\u5f02\u5730\u767b\u5f55\uff0c\u8bf7\u8054\u7cfb\u5ba2\u670d.", "\u64cd\u4f5c\u6210\u529f", "\u64cd\u4f5c\u5931\u8d25", "\u65b0\u5bc6\u7801\u8ddf\u65e7\u5bc6\u7801\u4e0d\u80fd\u4e00\u6837.", "\u62b1\u6b49\uff0c\u5f53\u524d\u6e38\u620f\u201c\u623f\u95f4\u5df2\u6ee1\u5ea7\u201d\u6682\u65f6\u65e0\u6cd5\u5165\u5ea7\uff0c\u8bf7\u7a0d\u540e\u518d\u8bd5\uff01", "\u62b1\u6b49\uff0c\u5f53\u524d\u6e38\u620f\u201c\u623f\u95f4\u5df2\u6ee1\u5ea7\u201d\u6682\u65f6\u65e0\u6cd5\u5165\u5ea7\uff0c\u8bf7\u7a0d\u540e\u518d\u8bd5\uff01", "\u62b1\u6b49\uff0c\u5df2\u6709\u73a9\u5bb6\u5360\u7528\uff0c\u8bf7\u7a0d\u540e\u518d\u8bd5\uff01", "\u6e38\u620f\u684c\u8fdb\u5165\u5bc6\u7801\u4e0d\u6b63\u786e\uff0c\u7981\u6b62\u8fdb\u5165\u3002"],
            en: ["", "We are sorry to inform you that your IP address has been banned from login by the system. \nPlease contact customer service center for more info.", "We are sorry to inform you that your device has been banned from login by the system. \nPlease contact customer service center for more info.", "Your account does not exist or password is incorrect. Please check and login again.", "Your account has been suspended. Please contact customer service center for more info.", "Your account has been disabled for security reason. \nIt will be available only after been reactivated. ", "Your account has been bound with a device. Please login with the bound device.", "Your account does not exist or password is incorrect. Please check and login again.", "Binding device failure due to invalid user info.", "Binding device failure due to unexpected error.", "Your account has been bound with another device. \nYou have to unbind it first and then bind with this device.", "Binding device failure due to unexpected error.", "Account binding device operation error. Please contact customer service center.", "Your account has been bound with this device successfully. \nYou have to use this device to unbind it if needed.", "Binding device failure due to invalid user info.", "Your account has been bound with another device. Unbinding device failure.", "Unbinding device failure due to unexpected error.", "Account unbinding device operation error. Please contact customer service center.", "Your account has been unbound with this device successfully.", "We are sorry to inform you that your IP address has been banned from game login by the system. \nPlease contact customer service center for more info.", "Your account does not exist or password is incorrect. Please check and login again.", "Your account has been suspended. Please contact customer service center for more info.", "Your account has been disabled for security reason. It will be available only after been reactivated.", "Your account has been bound with a device. Please login with the bound device.", "Sorry. Your account logs in at other IP address now. Please try again later.", "We are sorry to inform you that some exception was found in your game bank data. \nPlease contact customer service center for more info.", "Sorry. You are now playing the game and cannot join it at same time.", "Sorry. You are not allowed to join the game as the system detected \nthat your account is now playing game.", "Modify password successfully, please remember this new password.", "This account try to logon in another place, please change password.", "This account has logon in other place, please contact customer service.", "Operation success", "Operation fail", "New password should be different from old one.", "Sorry, You are not allowed to be seated as all the tables of the game have been occupied. \nPlease try again later!", "Sorry, You are not allowed to be seated as all the tables of the game have been occupied. \nPlease try again later!", "Sorry, the seat has been occupied by other player. Please try again later!", "You are not allowed to enter the game table as you input wrong password."],
            po: ["", "Desculpe por informar que o sistema pro\xedbe as permiss\xf5es de login do jogo do seu endere\xe7o IP, entre em contato com o Centro de Atendimento ao Cliente para saber mais!", "Lamentamos inform\xe1-lo de que seu dispositivo foi banido de login pelo sistema. Entre em contato com o Centro de Atendimento ao Cliente para mais informa\xe7\xf5es.", "Sua conta n\xe3o existe ou a senha est\xe1 incorreta. Por favor, verifique e fa\xe7a o login novamente.", "Sua conta foi suspensa. Entre em contato com o Centro de Atendimento ao Cliente para mais informa\xe7\xf5es.", "Sua conta usa uma fun\xe7\xe3o de desligamento segura, deve continuar a us\xe1-lo depois de reabrir isso!", "Sua conta usa um recurso de login de m\xe1quina fixa, a m\xe1quina que usa n\xe3o \xe9 a m\xe1quina especificada", "Sua conta n\xe3o existe ou a senha est\xe1 incorreta. Por favor, verifique e fa\xe7a o login novamente.", "Informa\xe7\xf5es do usu\xe1rio n\xe3o existe, a liga\xe7\xe3o da m\xe1quina falhou!", "Liga\xe7\xe3o da m\xe1quina falhou, erros desconhecidos!", "Sua conta foi vinculada a outras m\xe1quinas, deve ser liberado para executar opera\xe7\xf5es de liga\xe7\xe3o local!", "Liga\xe7\xe3o da m\xe1quina falhou, erros desconhecidos!", "A opera\xe7\xe3o de liga\xe7\xe3o de conta est\xe1 incorreta, entre em contato com o Centro de Atendimento ao Cliente!", "Sua conta \xe9 vinculativa com sucesso a esta m\xe1quina, se precisar liberar a liga\xe7\xe3o, precisa fazer esta m\xe1quina!", "Informa\xe7\xf5es do usu\xe1rio n\xe3o existe, a liga\xe7\xe3o da m\xe1quina falhou!", "Sua conta \xe9 obrigada a outras m\xe1quinas, e a m\xe1quina n\xe3o consegue falhar!", "Erro desconhecido, a m\xe1quina \xe9 lan\xe7ada!", "A opera\xe7\xe3o de liga\xe7\xe3o de libera\xe7\xe3o da conta est\xe1 incorreta, entre em contato com o Centro de Atendimento ao Cliente!", "Akaun dan mesin anda melepaskan pengikatan dengan berjaya!", "Lamentamos informar que seu endere\xe7o IP foi banido de login pelo sistema. Entre em contato com o Centro de Atendimento ao Cliente para mais informa\xe7\xf5es.", "Sua conta n\xe3o existe ou a senha est\xe1 incorreta. Por favor, verifique e fa\xe7a o login novamente.", "Sua conta foi suspensa. Entre em contato com o Centro de Atendimento ao Cliente para mais informa\xe7\xf5es.", "Sua conta usa uma fun\xe7\xe3o de desligamento segura, deve continuar a us\xe1-lo depois de reabrir isso!", "Sua conta usa um recurso de login de m\xe1quina fixa, a m\xe1quina que usa n\xe3o \xe9 a m\xe1quina especificada", "Desculpe, porque sua conta est\xe1 logada novamente, por favor, tente novamente depois de fazer login na plataforma!", "Desculpe por informar que seus dados de moedas de jogo t\xeam uma situa\xe7\xe3o anormal, entre em contato com o Centro de Atendimento ao Cliente para saber mais!", "Desculpe, est\xe1 na sala de jogos, n\xe3o pode entrar nesta sala de jogos ao mesmo tempo!", "Desculpe, o sistema detecta que sua conta est\xe1 no jogo, proibindo entrar na sala de jogos!", "A senha da conta \xe9 modificada, mantenha sua nova senha de conta", "Akaun ini cuba log masuk di tempat lain, sila ubah kata laluan.", "Akaun ini telah dilog masuk di tempat lain, sila hubungi khidmat pelanggan.", "Operasi berjaya", "Operasi gagal", "Kata laluan baru tidak boleh sama dengan kata laluan lama", "Desculpe, voc\xea n\xe3o tem permiss\xe3o para estar sentado, pois todas as mesas do jogo foram ocupadas. \nPor favor tente novamente mais tarde!", "Desculpe, voc\xea n\xe3o tem permiss\xe3o para estar sentado, pois todas as mesas do jogo foram ocupadas. \nPor favor tente novamente mais tarde!", "Desculpe, o lugar foi ocupado por outro jogador. Por favor tente novamente mais tarde!", "Voc\xea n\xe3o tem permiss\xe3o para entrar na mesa de jogo quando voc\xea digita senha errada."],
            sp: ["", "Lo sentimos informarle que la funci\xf3n de inicio de sesi\xf3n de su direcci\xf3n IP est\xe1 prohibida, favor de ponerse en contacto con el centro de servicio al cliente para m\xe1s detalles", "Lo sentimos informarle que la funci\xf3n de inicio de sesi\xf3n de su dispositivo est\xe1 prohibida, \xa1favor de ponerse en contacto con el centro de servicio al cliente para m\xe1s detalles!", "Su cuenta no existe o la contrase\xf1a se ingres\xf3 incorrectamente, \xa1favor de verifique e intente iniciar sesi\xf3n de nuevo!", "Su cuenta est\xe1 congelada temporalmente, \xa1favor de ponerse en contacto con el centro de servicio al cliente para m\xe1s detalles!", "Su cuenta se ha cerrado de forma segura. \xa1Debe volver a abrirla para seguir us\xe1ndola!", "Su cuenta utiliza la funci\xf3n de inicio de sesi\xf3n con el dispositivo fijo. \xa1El dispositivo que est\xe1 usando no es  el conectado!", "Tu cuenta no existe o tu contrase\xf1a es incorrecta. Por favor revise tu ingreso nuevamente.", "La informaci\xf3n del usuario no existe,  \xa1fall\xf3 el enlace del dispositivo!", "Error de enlace del dispositivo, error desconocido!", "Su cuenta se ha conectado al otro dispositivo. \xa1Debe deshacerla antes de conectar este dispositivo!", "Error de conectar el dispositivo, \xa1error desconocido!", "La operaci\xf3n del enlace de la cuenta se realiza incorrectamente, \xa1p\xf3ngase en contacto con el centro de servicio al cliente!", "Su cuenta se ha conectado correctamente a este dispositivo. Si necesita librarlo, \xa1debe hacerlo en este dispositivo!", "La informaci\xf3n del usuario no existe, \xa1fall\xf3 el enlace del dispositivo!", "Su cuenta est\xe1 conectada a otros dispositivos, \xa1fall\xf3 el desenlace del dispositivo!", "Error desconocido, \xa1fall\xf3 el enlace del dispositivo!", "La operaci\xf3n del desenlace de la cuenta se realiza incorrectamente, \xa1p\xf3ngase en contacto con el centro de servicio al cliente!", "\xa1Su cuenta se ha librado de su dispositivo!", "Lo sentimos informarle que el sistema se ha prohibido el permiso de inicio de sesi\xf3n del juego de su direcci\xf3n IP, \xa1favor de ponerse en contacto con el centro de servicio al cliente para m\xe1s detalles!", "Su cuenta no existe o la contrase\xf1a se ingres\xf3 incorrectamente, \xa1favor de verifique e intente iniciar sesi\xf3n de nuevo!", "Su cuenta est\xe1 congelada temporalmente, \xa1favor de ponerse en contacto con el centro de servicio al cliente para m\xe1s detalles!", "Su cuenta se ha cerrado de forma segura. \xa1Debe volver a abrirla para seguir us\xe1ndola!", "Su cuenta utiliza la funci\xf3n de inicio de sesi\xf3n con el dispositivo fijo. \xa1El dispositivo que est\xe1 usando no es  el conectado!", "Lo sentimos, debido a que su cuenta ha iniciado sesi\xf3n en otro lugar, \xa1vuelva a iniciar sesi\xf3n en la plataforma e int\xe9ntelo de nuevo!", "Lo sentimos informarle que hay anomal\xedas en los datos de moneda del juego, \xa1favor de ponerse en contacto con el centro de servicio al cliente para m\xe1s detalles!", "Lo sentimos, est\xe1 en otra sala de juegos. \xa1No puedes entrar a esta sala al mismo tiempo!", "Lo sentimos, el sistema ha detectado que su cuenta est\xe1 actualmente en el juego. \xa1Est\xe1 prohibido ingresar a la sala de juegos!", "La contrase\xf1a de la cuenta se ha modificado correctamente, recuerde la contrase\xf1a nueva de su cuenta", "Esta cuenta intenta iniciar sesi\xf3n desde otro lugar, favor de cambiar la contrase\xf1a.", "Esta cuenta se ha iniciado sesi\xf3n en otro lugar, comun\xedquese con el servicio al cliente.", "Operaci\xf3n exitosa", "Operaci\xf3n fallida", "La nueva contrase\xf1a no puede ser la misma que la contrase\xf1a anterior.", "\u62b1\u6b49\uff0c\u5f53\u524d\u6e38\u620f\u201c\u623f\u95f4\u5df2\u6ee1\u5ea7\u201d\u6682\u65f6\u65e0\u6cd5\u5165\u5ea7\uff0c\u8bf7\u7a0d\u540e\u518d\u8bd5\uff01", "\u62b1\u6b49\uff0c\u5f53\u524d\u6e38\u620f\u201c\u623f\u95f4\u5df2\u6ee1\u5ea7\u201d\u6682\u65f6\u65e0\u6cd5\u5165\u5ea7\uff0c\u8bf7\u7a0d\u540e\u518d\u8bd5\uff01", "\u62b1\u6b49\uff0c\u5df2\u6709\u73a9\u5bb6\u5360\u7528\uff0c\u8bf7\u7a0d\u540e\u518d\u8bd5\uff01", "\u6e38\u620f\u684c\u8fdb\u5165\u5bc6\u7801\u4e0d\u6b63\u786e\uff0c\u7981\u6b62\u8fdb\u5165\u3002"],
            vi: ["", "R\u1ea5t ti\u1ebfc ph\u1ea3i th\xf4ng b\xe1o cho b\u1ea1n, h\u1ec7 th\u1ed1ng \u0111\xe3 ch\u1eb7n ch\u1ee9c n\u0103ng \u0111\u0103ng nh\u1eadp t\u1eeb \u0111\u1ecba ch\u1ec9 IP c\u1ee7a b\u1ea1n, \nvui l\xf2ng li\xean h\u1ec7 trung t\xe2m d\u1ecbch v\u1ee5 kh\xe1ch h\xe0ng \u0111\u1ec3 bi\u1ebft chi ti\u1ebft", "R\u1ea5t ti\u1ebfc ph\u1ea3i th\xf4ng b\xe1o cho b\u1ea1n, h\u1ec7 th\u1ed1ng \u0111\xe3 ch\u1eb7n ch\u1ee9c n\u0103ng \u0111\u0103ng nh\u1eadp t\u1eeb thi\u1ebft b\u1ecb c\u1ee7a b\u1ea1n, \nvui l\xf2ng li\xean h\u1ec7 trung t\xe2m d\u1ecbch v\u1ee5 kh\xe1ch h\xe0ng \u0111\u1ec3 bi\u1ebft chi ti\u1ebft!", "T\xe0i kho\u1ea3n c\u1ee7a b\u1ea1n kh\xf4ng t\u1ed3n t\u1ea1i ho\u1eb7c nh\u1eadp sai m\u1eadt kh\u1ea9u, vui l\xf2ng ki\u1ec3m tra v\xe0 th\u1eed \u0111\u0103ng nh\u1eadp l\u1ea1i!", "T\xe0i kho\u1ea3n c\u1ee7a b\u1ea1n \u0111ang b\u1ecb t\u1ea1m kh\xf3a, vui l\xf2ng li\xean h\u1ec7 trung t\xe2m d\u1ecbch v\u1ee5 kh\xe1ch h\xe0ng \u0111\u1ec3 bi\u1ebft chi ti\u1ebft!", "T\xe0i kho\u1ea3n c\u1ee7a b\u1ea1n \u0111\xe3 b\u1ecb kh\xf3a v\xec l\xfd do an to\xe0n, ph\u1ea3i m\u1edf l\u1ea1i m\u1edbi c\xf3 th\u1ec3 ti\u1ebfp t\u1ee5c s\u1eed d\u1ee5ng!", "T\xe0i kho\u1ea3n c\u1ee7a b\u1ea1n \u0111\xe3 li\xean k\u1ebft v\u1edbi thi\u1ebft b\u1ecb c\u1ed1 \u0111\u1ecbnh, vui l\xf2ng \u0111\u0103ng nh\u1eadp b\u1eb1ng thi\u1ebft b\u1ecb \u0111\xe3 li\xean k\u1ebft", "T\xe0i kho\u1ea3n c\u1ee7a b\u1ea1n kh\xf4ng t\u1ed3n t\u1ea1i ho\u1eb7c nh\u1eadp sai m\u1eadt kh\u1ea9u, vui l\xf2ng ki\u1ec3m tra v\xe0 th\u1eed \u0111\u0103ng nh\u1eadp l\u1ea1i!", "Th\xf4ng tin ng\u01b0\u1eddi d\xf9ng kh\xf4ng t\u1ed3n t\u1ea1i, li\xean k\u1ebft thi\u1ebft b\u1ecb kh\xf4ng th\xe0nh c\xf4ng!", "Li\xean k\u1ebft thi\u1ebft b\u1ecb kh\xf4ng th\xe0nh c\xf4ng, l\u1ed7i ch\u01b0a x\xe1c \u0111\u1ecbnh!", "T\xe0i kho\u1ea3n c\u1ee7a b\u1ea1n \u0111\xe3 li\xean k\u1ebft v\u1edbi thi\u1ebft b\u1ecb kh\xe1c, ph\u1ea3i g\u1ee1 li\xean k\u1ebft m\u1edbi c\xf3 th\u1ec3 th\u1ef1c hi\u1ec7n li\xean k\u1ebft v\u1edbi thi\u1ebft b\u1ecb n\xe0y!", "Li\xean k\u1ebft thi\u1ebft b\u1ecb kh\xf4ng th\xe0nh c\xf4ng, l\u1ed7i ch\u01b0a x\xe1c \u0111\u1ecbnh!", "C\xf3 l\u1ed7i khi th\u1ef1c hi\u1ec7n li\xean k\u1ebft t\xe0i kho\u1ea3n, vui l\xf2ng li\xean h\u1ec7 trung t\xe2m d\u1ecbch v\u1ee5 kh\xe1ch h\xe0ng! ", "T\xe0i kho\u1ea3n c\u1ee7a b\u1ea1n \u0111\xe3 li\xean k\u1ebft th\xe0nh c\xf4ng v\u1edbi thi\u1ebft b\u1ecb n\xe0y, n\u1ebfu mu\u1ed1n g\u1ee1 li\xean k\u1ebft ph\u1ea3i th\u1ef1c hi\u1ec7n tr\xean thi\u1ebft b\u1ecb n\xe0y!", "Th\xf4ng tin ng\u01b0\u1eddi d\xf9ng kh\xf4ng t\u1ed3n t\u1ea1i, li\xean k\u1ebft thi\u1ebft b\u1ecb kh\xf4ng th\xe0nh c\xf4ng!", "T\xe0i kho\u1ea3n c\u1ee7a b\u1ea1n \u0111\xe3 li\xean k\u1ebft v\u1edbi thi\u1ebft b\u1ecb kh\xe1c, g\u1ee1 li\xean k\u1ebft thi\u1ebft b\u1ecb kh\xf4ng th\xe0nh c\xf4ng!", "L\u1ed7i ch\u01b0a x\xe1c \u0111\u1ecbnh, g\u1ee1 li\xean k\u1ebft kh\xf4ng th\xe0nh c\xf4ng!", "C\xf3 l\u1ed7i khi g\u1ee1 li\xean k\u1ebft t\xe0i kho\u1ea3n, vui l\xf2ng li\xean h\u1ec7 trung t\xe2m d\u1ecbch v\u1ee5 kh\xe1ch h\xe0ng!", "T\xe0i kho\u1ea3n c\u1ee7a b\u1ea1n \u0111\xe3 g\u1ee1 li\xean k\u1ebft thi\u1ebft b\u1ecb th\xe0nh c\xf4ng!", "R\u1ea5t ti\u1ebfc ph\u1ea3i th\xf4ng b\xe1o cho b\u1ea1n, h\u1ec7 th\u1ed1ng \u0111\xe3 ch\u1eb7n quy\u1ec1n h\u1ea1n \u0111\u0103ng nh\u1eadp tr\xf2 ch\u01a1i t\u1eeb \u0111\u1ecba ch\u1ec9 IP c\u1ee7a b\u1ea1n, \n vui l\xf2ng li\xean h\u1ec7 trung t\xe2m d\u1ecbch v\u1ee5 kh\xe1ch h\xe0ng \u0111\u1ec3 bi\u1ebft chi ti\u1ebft!", "T\xe0i kho\u1ea3n c\u1ee7a b\u1ea1n kh\xf4ng t\u1ed3n t\u1ea1i ho\u1eb7c nh\u1eadp sai m\u1eadt kh\u1ea9u, vui l\xf2ng ki\u1ec3m tra v\xe0 th\u1eed \u0111\u0103ng nh\u1eadp l\u1ea1i!", "T\xe0i kho\u1ea3n c\u1ee7a b\u1ea1n \u0111ang b\u1ecb t\u1ea1m kh\xf3a, vui l\xf2ng li\xean h\u1ec7 trung t\xe2m d\u1ecbch v\u1ee5 kh\xe1ch h\xe0ng \u0111\u1ec3 bi\u1ebft chi ti\u1ebft!", "T\xe0i kho\u1ea3n c\u1ee7a b\u1ea1n \u0111\xe3 b\u1ecb kh\xf3a v\xec l\xfd do an to\xe0n, ph\u1ea3i m\u1edf l\u1ea1i m\u1edbi c\xf3 th\u1ec3 ti\u1ebfp t\u1ee5c s\u1eed d\u1ee5ng!", "T\xe0i kho\u1ea3n c\u1ee7a b\u1ea1n \u0111\xe3 li\xean k\u1ebft v\u1edbi thi\u1ebft b\u1ecb c\u1ed1 \u0111\u1ecbnh, vui l\xf2ng \u0111\u0103ng nh\u1eadp b\u1eb1ng thi\u1ebft b\u1ecb \u0111\xe3 li\xean k\u1ebft", "Xin l\u1ed7i, do t\xe0i kho\u1ea3n c\u1ee7a b\u1ea1n \u0111\xe3 \u0111\u0103ng nh\u1eadp \u1edf n\u01a1i kh\xe1c, vui l\xf2ng th\u1eed \u0111\u0103ng nh\u1eadp l\u1ea1i!", "R\u1ea5t ti\u1ebfc ph\u1ea3i th\xf4ng b\xe1o cho b\u1ea1n, s\u1ed1 li\u1ec7u ti\u1ec1n trong tr\xf2 ch\u01a1i c\u1ee7a b\u1ea1n c\xf3 b\u1ea5t th\u01b0\u1eddng, \n vui l\xf2ng li\xean h\u1ec7 trung t\xe2m d\u1ecbch v\u1ee5 kh\xe1ch h\xe0ng \u0111\u1ec3 bi\u1ebft chi ti\u1ebft!", "Xin l\u1ed7i, b\u1ea1n \u0111\xe3 \u1edf trong ph\xf2ng game, kh\xf4ng th\u1ec3 tham gia l\u1ea1i v\xe0o ph\xf2ng game n\u1eefa!", "Xin l\u1ed7i, b\u1ea1n kh\xf4ng \u0111\u01b0\u1ee3c v\xe0o ph\xf2ng game v\xec h\u1ec7 th\u1ed1ng ki\u1ec3m tra th\u1ea5y t\xe0i kho\u1ea3n c\u1ee7a b\u1ea1n \u0111ang \u1edf trong tr\xf2 ch\u01a1i!", "Thay \u0111\u1ed5i m\u1eadt kh\u1ea9u t\xe0i kho\u1ea3n th\xe0nh c\xf4ng, h\xe3y ghi nh\u1edb m\u1eadt kh\u1ea9u m\u1edbi c\u1ee7a b\u1ea1n.", "T\xe0i kho\u1ea3n n\xe0y \u0111ang th\u1eed \u0111\u0103ng nh\u1eadp \u1edf n\u01a1i kh\xe1c, h\xe3y \u0111\u1ed5i m\u1eadt kh\u1ea9u.", "T\xe0i kho\u1ea3n n\xe0y \u0111\xe3 \u0111\u0103ng nh\u1eadp \u1edf n\u01a1i kh\xe1c, h\xe3y li\xean h\u1ec7 ch\u0103m s\xf3c kh\xe1ch h\xe0ng.", "Thao t\xe1c th\xe0nh c\xf4ng", "Thao t\xe1c th\u1ea5t b\u1ea1i", "M\u1eadt kh\u1ea9u m\u1edbi kh\xf4ng \u0111\u01b0\u1ee3c gi\u1ed1ng m\u1eadt kh\u1ea9u c\u0169", "R\u1ea5t ti\u1ebfc, hi\u1ec7n t\u1ea1i 'Ph\xf2ng \u0111\xe3 \u0111\u1ea7y', t\u1ea1m th\u1eddi kh\xf4ng th\u1ec3 v\xe0o ch\u1ed7, vui l\xf2ng th\u1eed l\u1ea1i sau!", "R\u1ea5t ti\u1ebfc, hi\u1ec7n t\u1ea1i 'Ph\xf2ng \u0111\xe3 \u0111\u1ea7y', t\u1ea1m th\u1eddi kh\xf4ng th\u1ec3 v\xe0o ch\u1ed7, vui l\xf2ng th\u1eed l\u1ea1i sau!", "R\u1ea5t ti\u1ebfc, \u0111\xe3 c\xf3 ng\u01b0\u1eddi ch\u01a1i chi\u1ebfm d\u1ee5ng, vui l\xf2ng th\u1eed l\u1ea1i sau!", "M\u1eadt m\xe3 v\xe0o b\xe0n kh\xf4ng ch\xednh x\xe1c, c\u1ea5m v\xe0o!"]
        },
        cc._RF.pop()
    }
    , {}],
    BufferPool: [function(e, t, o) {
        "use strict";
        cc._RF.push(t, "e7b0346HrZBLaGZMODdtM5E", "BufferPool"),
        Object.defineProperty(o, "__esModule", {
            value: !0
        }),
        o.BufferPool = void 0;
        var n = function() {
            function e(e) {
                this.buffer = new Array,
                this.using = new Array,
                this._createFunc = e
            }
            return e.prototype.allocate = function() {
                for (var e = [], t = 0; t < arguments.length; t++)
                    e[t] = arguments[t];
                var o = this.buffer.length > 0 ? this.buffer.pop() : this._createFunc.apply(this, e);
                return this.using.push(o),
                o
            }
            ,
            e.prototype.fastRecycleByIndex = function(e) {
                this.buffer.push(this.using[e]),
                cc.js.array.fastRemoveAt(this.using, e)
            }
            ,
            e.prototype.recycleByIndex = function(e) {
                this.buffer.push(this.using[e]),
                this.using.splice(e, 1)
            }
            ,
            e.prototype.recycle = function(e) {
                var t = this.using.findIndex(function(t) {
                    return e === t
                });
                this.fastRecycleByIndex(t)
            }
            ,
            e.prototype.clear = function() {
                var e;
                (e = this.buffer).push.apply(e, this.using),
                this.using.length = 0
            }
            ,
            e
        }();
        o.BufferPool = n,
        cc._RF.pop()
    }
    , {}],
    CardUI: [function(e, t, o) {
        "use strict";
        cc._RF.push(t, "4b3c8VGGd5K9I7dtrryIM78", "CardUI"),
        Object.defineProperty(o, "__esModule", {
            value: !0
        });
        var n = e("../../base/common/Func")
          , i = e("../../base/net/GameNet")
          , r = e("../../base/res/DyncMgr")
          , a = e("../../base/res/LanguageMgr")
          , s = e("../../base/SoundMgr")
          , c = e("../../base/common/Interface")
          , l = e("../../base/common/MessageMgr")
          , f = e("../../base/LogicMgr")
          , h = "link"
          , d = function() {
            function e(e) {
                this._loadIcon = !1,
                this._root = e;
                var t = e.getChildByName("logo");
                this._logoBtn = t.getComponent(cc.Button),
                this._logoBtn.enabled = !1;
                var o = t.getChildByName("iconTX");
                this._iconTXSpt = o.getComponent(cc.Sprite),
                this._iconTXSpt.spriteFrame = null,
                this._iconTXAnim = o.getComponent(cc.Animation);
                var n = o.getChildByName("icon");
                this._iconSpt = n.getComponent(cc.Sprite);
                var i = n.getChildByName("labelTX");
                this._labelTXSpt = i.getComponent(cc.Sprite),
                this._labelTXSpt.spriteFrame = null,
                this._labelTXAnim = i.getComponent(cc.Animation),
                this._loadingNode = n.getChildByName("loading"),
                this._loadingNode.active = !1,
                this._linkNode = n.getChildByName(h),
                this._favNode = n.getChildByName("fav"),
                this._favNode.active = !1,
                this._favBgNode = this._favNode.getChildByName(f.ConstDefine.Background),
                this._toggle = this._favNode.getComponent(cc.Toggle),
                this._favNode.on("toggle", this.toggleClick.bind(this)),
                this._tagChildren = n.getChildByName("tag").children;
                for (var r = 0; r < this._tagChildren.length; r++)
                    this._tagChildren[r].active = !1;
                t.on(f.ConstDefine.click, this.click.bind(this)),
                this._logoAnim = t.getComponent(cc.Animation),
                this._logoSpt = t.getComponent(cc.Sprite),
                this._nameNode = e.getChildByName("name"),
                this._nameNode.active = !1,
                this._nameLabel = this._nameNode.getComponent(cc.Label),
                this._nameLabel.string = ""
            }
            return Object.defineProperty(e.prototype, "cfg", {
                get: function() {
                    return this._cfg
                },
                enumerable: !1,
                configurable: !0
            }),
            e.prototype.click = function() {
                if (0 !== this._root.opacity) {
                    if (this._favNode.active)
                        return this._toggle.isChecked ? this._toggle.uncheck() : this._toggle.check(),
                        void this.toggleClick();
                    if (!f.default.login.testAcccount) {
                        if (this._cfg.t === c.GameTag.comingSoon)
                            return void r.default.getResInfo(f.ConstDefine.msgTip, a.default.procLangText("commingTip"));
                        if (-1 !== f.default.msgNotify.maintenance.indexOf(this._cfg.gid) || -1 !== f.default.msgNotify.maintenance.indexOf(-1))
                            return void r.default.getResInfo(f.ConstDefine.msgTip, a.default.procLangText("maintenanceTip"))
                    }
                    this._logoAnim.play(),
                    i.default.startGame(this._cfg)
                }
            }
            ,
            e.prototype.toggleClick = function() {
                0 !== this._root.opacity && (s.default.playEffect("favorite"),
                this._toggle.isChecked ? (e.FavCards.push(this.cfg),
                f.default.favArr.push(this.cfg.gid),
                this._favBgNode.active = !1) : (cc.js.array.remove(e.FavCards, this._cfg),
                cc.js.array.remove(f.default.favArr, this._cfg.gid),
                this._favBgNode.active = !0),
                this._cfg.fav = !this._favBgNode.active,
                l.MessageMgr.emit(l.MessageName.UpdateFavCards, this),
                localStorage.setItem(f.default.login.userID + "_favArrStr", JSON.stringify(f.default.favArr)))
            }
            ,
            e.prototype.init = function(e) {
                this.reset(e)
            }
            ,
            e.prototype.reset = function(e) {
                if (e.tag && e.tag[h]) {
                    this._linkNode.opacity = 255;
                    var t = e.tag[h];
                    "number" != typeof t && this._linkNode.setPosition(t[0], t[1])
                } else
                    this._linkNode.opacity = 0;
                e.card = this,
                this._cfg = e;
                for (var o = 0; o < this._tagChildren.length; ++o)
                    e.t == o ? (this._tagChildren[o].active = !0,
                    a.default.procLangNode(this._tagChildren[o])) : this._tagChildren[o].active = !1;
                if (f.default.login.testAcccount) {
                    this._nameNode.active = !0;
                    var n = this.cfg.address ? "" : "\nNo Table";
                    this._nameLabel.string = this.cfg.gameName + n
                } else
                    this._nameNode.active = !1;
                this.cfg.autoEnter && this.click(),
                e.fav ? (this._toggle.check(),
                this._favBgNode.active = !1) : (this._toggle.uncheck(),
                this._favBgNode.active = !0),
                this._iconSpt.spriteFrame = null,
                this._logoSpt.spriteFrame = null
            }
            ,
            e.prototype.setFavActive = function(e) {
                this._favNode.active = e
            }
            ,
            e.prototype.setParent = function(e) {
                this._root.setParent(e)
            }
            ,
            e.prototype.setActive = function(e) {
                e ? (this._cfg.logoSpt || (this._loadingNode.active = !0),
                this._logoBtn.enabled = !0,
                this._iconTXAnim.play(this._iconTXAnim.defaultClip.name, n.default.randomNum(0, this._iconTXAnim.defaultClip.duration)),
                this._labelTXAnim.play(this._labelTXAnim.defaultClip.name, n.default.randomNum(0, this._labelTXAnim.defaultClip.duration))) : (this._iconTXAnim.stop(),
                this._iconTXSpt.spriteFrame = null,
                this._labelTXAnim.stop(),
                this._labelTXSpt.spriteFrame = null,
                this._logoBtn.enabled = !1)
            }
            ,
            e.prototype.show = function(e) {
                this._root.opacity = e ? 255 : 0
            }
            ,
            e.prototype.setLogoSpt = function() {
                this._logoSpt.spriteFrame = this._cfg.logoSpt,
                this._loadingNode.active = !1
            }
            ,
            e.prototype.setIconSpt = function() {
                this._iconSpt.spriteFrame = this._cfg.iconSpt
            }
            ,
            e
        }();
        o.default = d,
        cc._RF.pop()
    }
    , {
        "../../base/LogicMgr": "LogicMgr",
        "../../base/SoundMgr": "SoundMgr",
        "../../base/common/Func": "Func",
        "../../base/common/Interface": "Interface",
        "../../base/common/MessageMgr": "MessageMgr",
        "../../base/net/GameNet": "GameNet",
        "../../base/res/DyncMgr": "DyncMgr",
        "../../base/res/LanguageMgr": "LanguageMgr"
    }],
    CashbackUI: [function(e, t, o) {
        "use strict";
        cc._RF.push(t, "12dccThR+tDc5l3hGgbfkxI", "CashbackUI");
        var n, i = this && this.__extends || (n = function(e, t) {
            return (n = Object.setPrototypeOf || {
                __proto__: []
            }instanceof Array && function(e, t) {
                e.__proto__ = t
            }
            || function(e, t) {
                for (var o in t)
                    Object.prototype.hasOwnProperty.call(t, o) && (e[o] = t[o])
            }
            )(e, t)
        }
        ,
        function(e, t) {
            function o() {
                this.constructor = e
            }
            n(e, t),
            e.prototype = null === t ? Object.create(t) : (o.prototype = t.prototype,
            new o)
        }
        );
        Object.defineProperty(o, "__esModule", {
            value: !0
        });
        var r = e("../config/Config")
          , a = e("../../base/SoundMgr")
          , s = e("../../base/common/view/Tip")
          , c = e("../../base/LogicMgr")
          , l = e("../../base/common/view/UIPicText")
          , f = e("../../base/common/MessageMgr")
          , h = e("../../base/common/view/CountdownTime")
          , d = e("../../base/net/NetMgr")
          , u = e("../../base/net/EEvent")
          , p = e("../../base/LevelMgr")
          , g = e("../../base/res/DyncMgr")
          , _ = cc.Vec3.ZERO
          , y = function(e) {
            function t() {
                var t = null !== e && e.apply(this, arguments) || this;
                return t._effectInfo = {
                    id: 0,
                    name: ""
                },
                t
            }
            return i(t, e),
            t.prototype.initParams = function() {
                e.prototype.initParams.call(this);
                var t = this._popupMethod.root.getChildByName("gold_pig");
                t.getChildByName("btn").on(c.ConstDefine.click, this.goldPigClick, this),
                t.on(c.ConstDefine.click, this.goldPigClick, this),
                this._goldPigSpine = t.getComponent(sp.Skeleton);
                var o = this._goldPigSpine.attachUtil;
                this._popupMethod.root.getChildByName("close").on(c.ConstDefine.click, this.close, this);
                var n = o.generateAttachedNodes("frame3")
                  , i = this._popupMethod.root.getChildByName("credit");
                i.parent = n[0],
                i.setPosition(0, 0),
                this._creditUIPic = new l.default("cashback",i),
                this._waitTimeNode = this._popupMethod.root.getChildByName("waitTime"),
                this._waitTimeNode.parent = n[0],
                this._waitTimeNode.setPosition(0, -100),
                this._countdownTime = new h.default(this._waitTimeNode.getChildByName("time").getComponent(cc.Label),c.default.reqUserInfo),
                this._collectNode = this._popupMethod.root.getChildByName("collect");
                var a = o.generateAttachedNodes("btn_collect");
                this._collectNode.parent = a[0],
                this._collectNode.setPosition(0, 0),
                this._collectNode.on(c.ConstDefine.click, this.collectClick, this),
                this._collectBtn = this._collectNode.getComponent(cc.Button),
                this._jinbiNode = this._popupMethod.root.getChildByName("jinbi"),
                p.default.Instance.setLevel(this._jinbiNode, r.AdaptLevel.creditUI);
                var s = this._popupMethod.root.getChildByName("eff_dianji");
                this._effClickPar = s.getComponentsInChildren(cc.ParticleSystem3D);
                var d = this._popupMethod.root.getChildByName("btn_rules")
                  , g = o.generateAttachedNodes("tanhao");
                d.parent = g[0],
                d.setPosition(0, 0),
                d.on(c.ConstDefine.click, this.showInstructions, this),
                this._instructionsNode = this._popupMethod.root.getChildByName("instructions"),
                this.hideInstructions(),
                this._instructionsNode.getChildByName("close").on(c.ConstDefine.click, this.hideInstructions, this);
                var _ = this._popupMethod.root.getChildByName("test");
                c.default.login.testAcccount ? _.on(c.ConstDefine.click, function() {
                    f.MessageMgr.emit(f.MessageName.NetMsg, {
                        mainID: u.Cmd.MDM_MB_LOGON,
                        subID: u.Cmd.SUB_GET_CASH_BACK_RESULT,
                        data: {
                            result: 0,
                            score: c.default.login.score + 100
                        }
                    })
                }) : _.destroy()
            }
            ,
            t.prototype.resetParams = function() {
                e.prototype.resetParams.call(this),
                this._goldPigSpine.setAnimation(0, "in", !1),
                this._goldPigSpine.addAnimation(0, "idle", !0),
                a.default.playEffect("pig_0", this._effectInfo),
                a.default.playEffect("pig_3"),
                a.default.pauseBGM(),
                c.default.reqUserInfo(),
                this._jinbiNode.setPosition(-5, -178),
                this.setJinbinodeScale(0),
                f.MessageMgr.emit(f.MessageName.ShowCreditBox, !1),
                f.MessageMgr.on(f.MessageName.NetMsg, this.onLogonNet, this),
                f.MessageMgr.on(f.MessageName.UserInfo, this.onUserInfo, this)
            }
            ,
            t.prototype.showInstructions = function() {
                a.default.playEffect(c.ConstDefine.click),
                this._instructionsNode.active = !0
            }
            ,
            t.prototype.hideInstructions = function() {
                a.default.playEffect(c.ConstDefine.click),
                this._instructionsNode.active = !1
            }
            ,
            t.prototype.setJinbinodeScale = function(e) {
                for (var t = 0, o = this._jinbiNode.children; t < o.length; t++)
                    o[t].setScale(e)
            }
            ,
            t.prototype.netOpen = function() {
                var e = {
                    userid: c.default.login.userID,
                    dynamicpass: c.default.login.dynamicPass
                };
                d.NetMgr.send(u.Cmd.MDM_MB_LOGON, u.Cmd.SUB_GET_CASH_BACK, e)
            }
            ,
            t.prototype.collectClick = function() {
                c.default.fuliData.blotterycashback ? c.default.fuliData.cashbackscore <= 0 ? g.default.getResInfo(c.ConstDefine.msgTip, "no score to get") : (a.default.playEffect("pigCollect"),
                this._collectBtn.interactable = !1,
                d.NetMgr.createWebSocket(),
                f.MessageMgr.once(f.MessageName.NetOpen, this.netOpen, this)) : g.default.getResInfo(c.ConstDefine.msgTip, "Welcome to collect again tomorrow, continue the game points can accumulate oh.")
            }
            ,
            t.prototype.goldPigClick = function() {
                a.default.playEffect("pig_1");
                for (var e = 0, t = this._effClickPar; e < t.length; e++) {
                    var o = t[e];
                    o.stop(),
                    o.play()
                }
            }
            ,
            t.prototype.close = function() {
                a.default.stopEffect(this._effectInfo.id, this._effectInfo.name),
                a.default.resumeBGM(),
                this.setJinbinodeScale(0),
                this._countdownTime.end(),
                f.MessageMgr.emit(f.MessageName.ShowCreditBox, !0),
                f.MessageMgr.off(f.MessageName.NetMsg, this.onLogonNet, this),
                f.MessageMgr.off(f.MessageName.UserInfo, this.onUserInfo, this),
                e.prototype.close.call(this)
            }
            ,
            t.prototype.onUserInfo = function() {
                c.default.fuliData.blotterycashback ? (this._waitTimeNode.active = !1,
                this._collectNode.color = cc.Color.WHITE,
                this._creditUIPic.setValue(c.default.fuliData.cashbackscore)) : (this._creditUIPic.setValue(c.default.fuliData.cashbackscore, c.default.login.creditPrefix),
                this._collectNode.color = cc.Color.GRAY,
                this._waitTimeNode.active = !0,
                this._countdownTime.start(c.default.fuliData.refreshtimecashback))
            }
            ,
            t.prototype.onLogonNet = function(e) {
                if (e.mainID === u.Cmd.MDM_MB_LOGON && e.subID === u.Cmd.SUB_GET_CASH_BACK_RESULT)
                    if (this._collectBtn.interactable = !0,
                    console.log("\u91d1\u732a\u7f51\u7edc\u6d88\u606f\u8fd4\u56de", e),
                    0 === e.data.result) {
                        f.MessageMgr.emit(f.MessageName.ShowCreditBox, !0),
                        a.default.playEffect("pig_2"),
                        this.setJinbinodeScale(3);
                        for (var t = 0, o = this._jinbiNode.children; t < o.length; t++) {
                            var n = o[t];
                            cc.tween(n).to(1, {
                                scale: 1.5
                            }).start()
                        }
                        var i = c.default.creditNode.parent.convertToWorldSpaceAR(c.default.creditNode.position);
                        this._jinbiNode.parent.convertToNodeSpaceAR(i, _),
                        cc.tween(this._jinbiNode).to(1.5, {
                            position: _
                        }).delay(1.6).call(this.showEnd.bind(this)).start(),
                        c.default.login.score = e.data.score
                    } else
                        g.default.getResInfo(c.ConstDefine.msgTip, "session timeout, please log in again!")
            }
            ,
            t.prototype.showEnd = function() {
                f.MessageMgr.emit(f.MessageName.UpdateCredit),
                this.close()
            }
            ,
            t
        }(s.PopupBase);
        o.default = y,
        cc._RF.pop()
    }
    , {
        "../../base/LevelMgr": "LevelMgr",
        "../../base/LogicMgr": "LogicMgr",
        "../../base/SoundMgr": "SoundMgr",
        "../../base/common/MessageMgr": "MessageMgr",
        "../../base/common/view/CountdownTime": "CountdownTime",
        "../../base/common/view/Tip": "Tip",
        "../../base/common/view/UIPicText": "UIPicText",
        "../../base/net/EEvent": "EEvent",
        "../../base/net/NetMgr": "NetMgr",
        "../../base/res/DyncMgr": "DyncMgr",
        "../config/Config": "Config"
    }],
    Config: [function(e, t, o) {
        "use strict";
        cc._RF.push(t, "1140euUrztH3ogUNzOL4vdh", "Config"),
        Object.defineProperty(o, "__esModule", {
            value: !0
        }),
        o.AdaptLevel = o.Config = void 0,
        o.Config = {
            debug: !0,
            autoLogin: !1,
            autoEnterGame: void 0,
            gameCback: void 0,
            testAcFormat: void 0,
            pcUseSoftKey: !0,
            iframe: !1,
            basePath: "",
            urlParam: "",
            configPath: "",
            platName: "orionstars",
            platLinkName: void 0,
            version: "2.0.1",
            bsIp: "",
            wsPort: 8600,
            wsUrl: "",
            bsPort: 8580,
            bsUrl: "",
            gmUrl: void 0,
            prizeNum: 20,
            prize1: [0, 3, 13, 50, 200, 0, 7, 20, 100, 400, 0, 5, 15, 75, 300, 0, 10, 25, 150, 500],
            jpRollVal: [[15e4, 17e4, 26e4, 28e4], [5e4, 6e4, 9e4, 1e5], [1e4, 1e4, 5e4, 5e4], [2e3, 2e3, 1e4, 1e4]],
            gameProtocol: "ws://",
            wsProtocol: "wl",
            defaultLang: "en",
            usingLang: ["en", "sp"],
            decimalPlaces: 2,
            decimal: 100,
            accPwdMinLength: 6,
            accPwdMaxLength: 32,
            beginPage: "hallUI",
            VisitNotice: void 0,
            rocketRamp: void 0,
            outScreenPos: void 0,
            center: [640, 360],
            gameSize: [1280, 720],
            dyncBundleUrl: [{
                url: "dync"
            }],
            dyncLoadDirIndex: {
                headIcon: 0,
                beautyLogo: 0,
                loginUI: 0,
                jackPot: 0,
                hallUI: 0,
                advert: 0
            },
            soundCfg: {
                load: {
                    click: {
                        norecycle: !0
                    }
                }
            },
            guangGao: [],
            bigGG: [],
            kapian: [],
            kpSortGid: [],
            testGames: [],
            backStageUrl: "",
            welfarePrize: {
                lottery_period: !0,
                cashBack_period: 1,
                fuDai_period: 1
            },
            theme: ""
        },
        function(e) {
            e[e.hallUI = 0] = "hallUI",
            e[e.loginUI = 1] = "loginUI",
            e[e.creditUI = 2] = "creditUI",
            e[e.jpUI = 3] = "jpUI",
            e[e.msgTip = 4] = "msgTip",
            e[e.msgTip2 = 5] = "msgTip2",
            e[e.clickTip = 6] = "clickTip",
            e[e.keyboardUI = 7] = "keyboardUI",
            e[e.loadTip = 8] = "loadTip",
            e[e.bounderyMask = 9] = "bounderyMask",
            e[e.debug = 10] = "debug",
            e[e.num = 11] = "num"
        }(o.AdaptLevel || (o.AdaptLevel = {})),
        o.Config.outScreenPos = cc.v2(12800, 7200),
        cc._RF.pop()
    }
    , {}],
    CountdownTime: [function(e, t, o) {
        "use strict";
        cc._RF.push(t, "b9d2fbTAR9E6YcWqlBtOmVF", "CountdownTime"),
        Object.defineProperty(o, "__esModule", {
            value: !0
        });
        var n = e("../Func")
          , i = function() {
            function e(e, t) {
                this._hours = 0,
                this._minutes = 0,
                this._seconds = 0,
                this._leftTime = 0,
                this._label = e,
                this._callfunc = t
            }
            return e.prototype.start = function(e) {
                "" == e && (e = "23:59:59"),
                this._leftTime = n.default.timeStr2Second(e);
                var t = this._leftTime;
                this._hours = Math.floor(t / 3600),
                t %= 3600,
                this._minutes = Math.floor(t / 60),
                this._seconds = t % 60,
                this._interval = setInterval(this.updateSecond.bind(this), 1e3)
            }
            ,
            e.prototype.end = function() {
                clearInterval(this._interval)
            }
            ,
            e.prototype.updateSecond = function() {
                if (--this._leftTime <= 0)
                    clearInterval(this._interval),
                    this._callfunc();
                else {
                    --this._seconds < 0 && (this._seconds = 59,
                    --this._minutes < 0 && (this._minutes = 59,
                    --this._hours < 0 && (this._hours = 11)));
                    var e = cc.js.formatStr("%s:%s:%s", n.default.fillZero(this._hours), n.default.fillZero(this._minutes), n.default.fillZero(this._seconds));
                    this._label.string = e
                }
            }
            ,
            e
        }();
        o.default = i,
        cc._RF.pop()
    }
    , {
        "../Func": "Func"
    }],
    CustomScrollView: [function(e, t, o) {
        "use strict";
        cc._RF.push(t, "abb4cMq1jZPUZwG6hDCr2qt", "CustomScrollView"),
        Object.defineProperty(o, "__esModule", {
            value: !0
        }),
        o.CustomScrollView = void 0;
        var n = function() {
            function e() {}
            return e.addScrollBarExtra = function(e) {
                var t = e.getComponent(cc.ScrollView)
                  , o = e;
                o._bubblingListeners = o._capturingListeners,
                o._capturingListeners = void 0;
                var n = t.verticalScrollBar
                  , i = !1
                  , r = n.handle.node
                  , a = r.parent.getContentSize();
                function s(e) {
                    var t = e.getContentSize()
                      , o = 0
                      , n = 0;
                    return a.height > t.height && (o = a.height / 2 - t.height,
                    n = -a.height / 2),
                    {
                        minY: n,
                        maxY: o
                    }
                }
                r.on(cc.Node.EventType.TOUCH_START, function(e) {
                    i = !0,
                    e.stopPropagation()
                }),
                r.on(cc.Node.EventType.TOUCH_MOVE, function(e) {
                    if (i) {
                        var o = e.target
                          , n = s(o)
                          , r = n.minY
                          , a = n.maxY;
                        o.y += e.getDeltaY(),
                        o.y > a ? o.y = a : o.y < r && (o.y = r),
                        e.stopPropagation();
                        var c = (o.y - r) / (a - r)
                          , l = t.getMaxScrollOffset();
                        l.y *= 1 - c,
                        l.y += t._topBoundary,
                        t.setContentPosition(l)
                    }
                }),
                r.on(cc.Node.EventType.TOUCH_END, function(e) {
                    i = !1,
                    e.stopPropagation()
                }),
                r.on(cc.Node.EventType.TOUCH_CANCEL, function(e) {
                    i = !1,
                    e.stopPropagation()
                })
            }
            ,
            e
        }();
        o.CustomScrollView = n,
        cc._RF.pop()
    }
    , {}],
    DebugMgr: [function(e, t, o) {
        "use strict";
        cc._RF.push(t, "e8f99efeudFLboa8n1x31iq", "DebugMgr");
        var n, i = this && this.__extends || (n = function(e, t) {
            return (n = Object.setPrototypeOf || {
                __proto__: []
            }instanceof Array && function(e, t) {
                e.__proto__ = t
            }
            || function(e, t) {
                for (var o in t)
                    Object.prototype.hasOwnProperty.call(t, o) && (e[o] = t[o])
            }
            )(e, t)
        }
        ,
        function(e, t) {
            function o() {
                this.constructor = e
            }
            n(e, t),
            e.prototype = null === t ? Object.create(t) : (o.prototype = t.prototype,
            new o)
        }
        );
        Object.defineProperty(o, "__esModule", {
            value: !0
        });
        var r = e("../common/MessageMgr")
          , a = e("../../my/config/Config")
          , s = e("../res/DyncLoadedBase")
          , c = e("../res/DyncMgr")
          , l = e("../net/EEvent")
          , f = e("../common/Func")
          , h = e("../LogicMgr")
          , d = function(e) {
            function t() {
                var t = null !== e && e.apply(this, arguments) || this;
                return t._touchPos = cc.Vec2.ZERO,
                t
            }
            return i(t, e),
            t.prototype.initParams = function() {
                this._rootNode = this.nodeInfo.root.getChildByName("root"),
                this._rootNode.getChildByName(h.ConstDefine.close).on("click", this.closeClick, this),
                this._rootNode.getChildByName("openDailyBonus").on(h.ConstDefine.click, function() {
                    c.default.getResInfo(h.ConstDefine.rollPrize)
                }),
                this._rootNode.getChildByName("testDailyBonus").on(h.ConstDefine.click, function() {
                    var e = a.Config.prize1[f.default.randomInt(0, a.Config.prizeNum - 1)];
                    r.MessageMgr.emit(r.MessageName.NetMsg, {
                        mainID: l.Cmd.MDM_MB_LOGON,
                        subID: l.Cmd.SUB_MB_LOGON_CHOUJIANG_RESULT,
                        data: {
                            result: 0,
                            lotteryscore: e
                        }
                    })
                }),
                r.MessageMgr.on(r.MessageName.TouchStart, this.touchStart, this),
                r.MessageMgr.on(r.MessageName.TouchEnd, this.touchEnd, this),
                this.closeClick()
            }
            ,
            t.prototype.closeClick = function() {
                cc.debug.setDisplayStats(!1),
                this._rootNode.active = !1,
                window.vConsole && (window.vConsole.$dom.style.display = "none")
            }
            ,
            t.prototype.touchStart = function(e) {
                h.default.login.testAcccount && this._touchPos.set(e.getLocation())
            }
            ,
            t.prototype.touchEnd = function(e) {
                h.default.login.testAcccount && this._touchPos.x < 10 && e.getLocation().x - this._touchPos.x > 30 && (this._rootNode.active = !0,
                cc.debug.setDisplayStats(!0),
                window.vConsole && (window.vConsole.$dom.style.display = "inline"))
            }
            ,
            t
        }(s.default);
        o.default = d,
        cc._RF.pop()
    }
    , {
        "../../my/config/Config": "Config",
        "../LogicMgr": "LogicMgr",
        "../common/Func": "Func",
        "../common/MessageMgr": "MessageMgr",
        "../net/EEvent": "EEvent",
        "../res/DyncLoadedBase": "DyncLoadedBase",
        "../res/DyncMgr": "DyncMgr"
    }],
    DyncAnimPlay: [function(e, t, o) {
        "use strict";
        cc._RF.push(t, "6f4e6UBD7lDRYnvztavSTsI", "DyncAnimPlay");
        var n, i = this && this.__extends || (n = function(e, t) {
            return (n = Object.setPrototypeOf || {
                __proto__: []
            }instanceof Array && function(e, t) {
                e.__proto__ = t
            }
            || function(e, t) {
                for (var o in t)
                    Object.prototype.hasOwnProperty.call(t, o) && (e[o] = t[o])
            }
            )(e, t)
        }
        ,
        function(e, t) {
            function o() {
                this.constructor = e
            }
            n(e, t),
            e.prototype = null === t ? Object.create(t) : (o.prototype = t.prototype,
            new o)
        }
        );
        Object.defineProperty(o, "__esModule", {
            value: !0
        }),
        o.WebAnim = void 0;
        var r = function(e) {
            function t() {
                return null !== e && e.apply(this, arguments) || this
            }
            return i(t, e),
            t.prototype.initParams = function() {
                e.prototype.initParams.call(this),
                this._anims = this._nodeInfo.root.getComponentsInChildren(cc.Animation);
                for (var t = 0, o = 0, n = this._anims; o < n.length; o++) {
                    var i = n[o].defaultClip.duration;
                    i > t && (t = i)
                }
                this._playTime = 1e3 * (t + .2)
            }
            ,
            t.prototype.resetParams = function(t, o, n) {
                var i = this;
                e.prototype.resetParams.call(this);
                for (var r = 0, a = this._anims; r < a.length; r++)
                    a[r].play();
                this._nodeInfo.root.setPosition(t),
                null != o && (this._nodeInfo.root.scale = o),
                null != n && (this._nodeInfo.root.angle = n),
                setTimeout(function() {
                    i.hide()
                }, this._playTime)
            }
            ,
            t
        }(e("./DyncLoadedBase").default);
        o.default = r;
        var a = function(e) {
            function t() {
                return null !== e && e.apply(this, arguments) || this
            }
            return i(t, e),
            t.prototype.resetParams = function(t) {
                e.prototype.resetParams.call(this, t)
            }
            ,
            t
        }(r);
        o.WebAnim = a,
        cc._RF.pop()
    }
    , {
        "./DyncLoadedBase": "DyncLoadedBase"
    }],
    DyncInfo: [function(e, t, o) {
        "use strict";
        cc._RF.push(t, "8bf76NT3plNgoZbeWjHUKW2", "DyncInfo");
        var n, i = this && this.__extends || (n = function(e, t) {
            return (n = Object.setPrototypeOf || {
                __proto__: []
            }instanceof Array && function(e, t) {
                e.__proto__ = t
            }
            || function(e, t) {
                for (var o in t)
                    Object.prototype.hasOwnProperty.call(t, o) && (e[o] = t[o])
            }
            )(e, t)
        }
        ,
        function(e, t) {
            function o() {
                this.constructor = e
            }
            n(e, t),
            e.prototype = null === t ? Object.create(t) : (o.prototype = t.prototype,
            new o)
        }
        ), r = this && this.__spreadArrays || function() {
            for (var e = 0, t = 0, o = arguments.length; t < o; t++)
                e += arguments[t].length;
            var n = Array(e)
              , i = 0;
            for (t = 0; t < o; t++)
                for (var r = arguments[t], a = 0, s = r.length; a < s; a++,
                i++)
                    n[i] = r[a];
            return n
        }
        ;
        Object.defineProperty(o, "__esModule", {
            value: !0
        }),
        o.MulNodeInfo = o.SingleNodeInfo = o.DyncResInfo = o.DyncInstanceInfo = o.DyncNodeInfo = void 0;
        var a = e("../common/BufferPool")
          , s = e("../common/view/NodeHandle")
          , c = e("../LevelMgr")
          , l = e("../LogicMgr")
          , f = e("./DyncMgr")
          , h = e("./LanguageMgr")
          , d = function() {
            function e(e) {
                this.cfg = e,
                this._nodeHanle = s.createNodeHandle(e.handle)
            }
            return e.prototype.init = function(e) {
                for (var t = [], o = 1; o < arguments.length; o++)
                    t[o - 1] = arguments[o];
                e.active = !0,
                this.root = e,
                this.setParentNode()
            }
            ,
            e.prototype.reset = function() {
                for (var e = [], t = 0; t < arguments.length; t++)
                    e[t] = arguments[t];
                this._nodeHanle.reset(this.root)
            }
            ,
            e.prototype.clear = function() {
                this._nodeHanle.clear(this.root)
            }
            ,
            e.prototype.destory = function() {
                cc.isValid(this.root) && (this.root.destroy(),
                this.root = null)
            }
            ,
            e.prototype.setParentNode = function() {
                void 0 !== this.cfg.layer && c.default.Instance.setLevel(this.root, this.cfg.layer)
            }
            ,
            e
        }();
        o.DyncNodeInfo = d;
        var u = function(e) {
            function t(t, o) {
                var n = e.call(this, t, o) || this;
                return n.dyncLoadedBase = new t.class(o,n),
                n
            }
            return i(t, e),
            t.prototype.init = function(t) {
                for (var o, n = [], i = 1; i < arguments.length; i++)
                    n[i - 1] = arguments[i];
                e.prototype.init.call(this, t),
                this.dyncLoadedBase.initParams(),
                (o = this.dyncLoadedBase).resetParams.apply(o, n)
            }
            ,
            t.prototype.reset = function() {
                for (var t, o = [], n = 0; n < arguments.length; n++)
                    o[n] = arguments[n];
                (this._nodeHanle.isReset(this.root) || this.dyncLoadedBase.isReset()) && (t = this.dyncLoadedBase).resetParams.apply(t, o),
                e.prototype.reset.call(this)
            }
            ,
            t.prototype.clear = function() {
                e.prototype.clear.call(this),
                this.dyncLoadedBase.clear()
            }
            ,
            t.prototype.destory = function() {
                e.prototype.destory.call(this),
                this.dyncLoadedBase.destroy()
            }
            ,
            t
        }(d);
        function p(e, t) {
            return void 0 === e && (e = {}),
            e.class ? new u(e,t) : new d(e,t)
        }
        o.DyncInstanceInfo = u;
        var g = function() {
            function e() {}
            return e.prototype.load = function(e) {
                for (var t = [], o = 1; o < arguments.length; o++)
                    t[o - 1] = arguments[o];
                return new Promise(function(o) {
                    f.default.bundles[e.cfg.loadIndex].load(e.cfg.path, e.cfg.loadType, function(n, i) {
                        e.cfg.loadingTip && f.default.hide(l.ConstDefine.loadingTip),
                        n ? (console.warn("\u52a0\u8f7d\u8d44\u6e90\u5931\u8d25", e.name),
                        o(null)) : (e.asset !== i ? (e.asset = i,
                        i.addRef(),
                        e.loadCall.apply(e, r([!0], t))) : e.loadCall.apply(e, r([!1], t)),
                        o(e))
                    })
                }
                )
            }
            ,
            e
        }()
          , _ = function(e) {
            function t(t) {
                var o = e.call(this, t) || this;
                return o._cfg = t,
                o._basePath = t.path,
                o
            }
            return i(t, e),
            t.prototype.changePath = function(e) {
                this._lastLangName = e,
                this._cfg.path = "lang/" + this._lastLangName + "/" + this._basePath
            }
            ,
            t.prototype.load = function(t) {
                for (var o = this, n = [], i = 1; i < arguments.length; i++)
                    n[i - 1] = arguments[i];
                return new Promise(function(i) {
                    o._lastLangName !== h.default.currLang && (o.changePath(h.default.currLang),
                    t.destroy()),
                    e.prototype.load.apply(o, r([t], n)).then(function(a) {
                        null === a ? (o.changePath(h.default.defaultLang),
                        i(e.prototype.load.apply(o, r([t], n)))) : i(a)
                    })
                }
                )
            }
            ,
            t
        }(g)
          , y = function() {
            function e(e, t) {
                this.name = t,
                this.cfg = e,
                this.asset = null,
                e.loadMode ? this.loadMode = new _(e) : this.loadMode = new g(e),
                void 0 === this.cfg.loadType && (this.cfg.loadType = cc.Prefab),
                void 0 === this.cfg.loadIndex && (this.cfg.loadIndex = 0)
            }
            return e.prototype.load = function() {
                for (var e = this, t = [], o = 0; o < arguments.length; o++)
                    t[o] = arguments[o];
                return new Promise(function(o) {
                    var n;
                    e.asset ? o(e) : (e.cfg.loadingTip && f.default.getResInfo(l.ConstDefine.loadingTip),
                    o((n = e.loadMode).load.apply(n, r([e], t))))
                }
                )
            }
            ,
            e.prototype.loadCall = function(e) {
                for (var t = [], o = 1; o < arguments.length; o++)
                    t[o - 1] = arguments[o];
                e && !this.canShow && f.default.hide(this.name)
            }
            ,
            e.prototype.clear = function() {}
            ,
            e.prototype.destroy = function() {
                this.asset && (this.asset.decRef(),
                this.asset = null)
            }
            ,
            e
        }();
        o.DyncResInfo = y;
        var m = function(e) {
            function t(t, o) {
                var n = e.call(this, t, o) || this;
                return n.nodeInfo = p(t.nodeCfg, o),
                n
            }
            return i(t, e),
            t.prototype.load = function() {
                for (var t = this, o = [], n = 0; n < arguments.length; n++)
                    o[n] = arguments[n];
                return new Promise(function(n) {
                    var i;
                    t.asset ? ((i = t.nodeInfo).reset.apply(i, o),
                    n(t)) : n(e.prototype.load.apply(t, o))
                }
                )
            }
            ,
            t.prototype.loadCall = function(t) {
                for (var o, n, i = [], a = 1; a < arguments.length; a++)
                    i[a - 1] = arguments[a];
                t ? (o = this.nodeInfo).init.apply(o, r([cc.instantiate(this.asset)], i)) : (n = this.nodeInfo).reset.apply(n, i),
                e.prototype.loadCall.call(this, t)
            }
            ,
            t.prototype.clear = function() {
                this.nodeInfo.clear()
            }
            ,
            t.prototype.destroy = function() {
                this.nodeInfo.destory(),
                e.prototype.destroy.call(this)
            }
            ,
            t
        }(y);
        o.SingleNodeInfo = m;
        var v = function(e) {
            function t() {
                var t = null !== e && e.apply(this, arguments) || this;
                return t._invailNodeInfo = [],
                t._nodePoolMgr = new a.BufferPool(p),
                t
            }
            return i(t, e),
            t.prototype.load = function() {
                for (var t = this, o = [], n = 0; n < arguments.length; n++)
                    o[n] = arguments[n];
                return new Promise(function(n) {
                    if (t.asset) {
                        var i = t._nodePoolMgr.allocate(t.cfg.nodeCfg, t.name);
                        i.root ? i.reset.apply(i, o) : i.init.apply(i, r([cc.instantiate(t.asset)], o)),
                        n(t)
                    } else
                        n(e.prototype.load.apply(t, o))
                }
                )
            }
            ,
            t.prototype.loadCall = function(e) {
                for (var t = [], o = 1; o < arguments.length; o++)
                    t[o - 1] = arguments[o];
                var n = null;
                (n = this._invailNodeInfo.length > 0 ? this._invailNodeInfo.pop() : p(this.cfg.nodeCfg, this.name)).init.apply(n, r([cc.instantiate(this.asset)], t)),
                this._nodePoolMgr.using.push(n)
            }
            ,
            t.prototype.clear = function(e) {
                this._nodePoolMgr.recycle(e),
                e.clear()
            }
            ,
            t.prototype.destroy = function(t) {
                t.destory();
                var o = this._nodePoolMgr.using
                  , n = o.findIndex(function(e) {
                    return e === t
                });
                -1 === n && (n = this._nodePoolMgr.buffer.findIndex(function(e) {
                    return e === t
                })),
                this._invailNodeInfo.push(o[n]),
                cc.js.array.fastRemoveAt(o, n),
                o.length <= 0 && this._nodePoolMgr.buffer.length <= 0 && e.prototype.destroy.call(this)
            }
            ,
            t.prototype.getCurNodeInfo = function() {
                var e = this._nodePoolMgr.using;
                return e[e.length - 1]
            }
            ,
            t
        }(y);
        o.MulNodeInfo = v,
        cc._RF.pop()
    }
    , {
        "../LevelMgr": "LevelMgr",
        "../LogicMgr": "LogicMgr",
        "../common/BufferPool": "BufferPool",
        "../common/view/NodeHandle": "NodeHandle",
        "./DyncMgr": "DyncMgr",
        "./LanguageMgr": "LanguageMgr"
    }],
    DyncLoadedBase: [function(e, t, o) {
        "use strict";
        cc._RF.push(t, "3b3c6DwlLZIGr07l9dvroHP", "DyncLoadedBase");
        var n, i = this && this.__extends || (n = function(e, t) {
            return (n = Object.setPrototypeOf || {
                __proto__: []
            }instanceof Array && function(e, t) {
                e.__proto__ = t
            }
            || function(e, t) {
                for (var o in t)
                    Object.prototype.hasOwnProperty.call(t, o) && (e[o] = t[o])
            }
            )(e, t)
        }
        ,
        function(e, t) {
            function o() {
                this.constructor = e
            }
            n(e, t),
            e.prototype = null === t ? Object.create(t) : (o.prototype = t.prototype,
            new o)
        }
        );
        Object.defineProperty(o, "__esModule", {
            value: !0
        }),
        o.DyncLangNode = o.DyncLangSprite = o.DyncSetParent = o.DyncSetSprite = o.DyncScaleSmall = void 0;
        var r = e("../LogicMgr")
          , a = e("../ScreenMgr")
          , s = e("../SoundMgr")
          , c = e("./DyncMgr")
          , l = function() {
            function e(e, t) {
                this._name = e,
                this._nodeInfo = t
            }
            return Object.defineProperty(e.prototype, "nodeInfo", {
                get: function() {
                    return this._nodeInfo
                },
                enumerable: !1,
                configurable: !0
            }),
            e.prototype.initParams = function() {}
            ,
            e.prototype.isReset = function() {
                return !1
            }
            ,
            e.prototype.resetParams = function() {
                for (var e = [], t = 0; t < arguments.length; t++)
                    e[t] = arguments[t]
            }
            ,
            e.prototype.clear = function() {}
            ,
            e.prototype.destroy = function() {}
            ,
            e.prototype.hide = function() {
                c.default.hide(this._name, this._nodeInfo)
            }
            ,
            e.prototype.close = function() {
                s.default.playEffect(r.ConstDefine.click),
                this.hide()
            }
            ,
            e
        }();
        o.default = l;
        var f = function(e) {
            function t() {
                var t = null !== e && e.apply(this, arguments) || this;
                return t._scaleMode = a.ScreenMode.fitScreen,
                t
            }
            return i(t, e),
            t.prototype.initParams = function() {
                e.prototype.initParams.call(this),
                this._angleRoot = this._nodeInfo.root.children[0]
            }
            ,
            t.prototype.resetParams = function() {
                for (var e = [], t = 0; t < arguments.length; t++)
                    e[t] = arguments[t];
                this.setScaleMode(a.default.Instance.curScale, a.default.Instance.screenMode)
            }
            ,
            t.prototype.setScaleMode = function(e, t) {
                this._scaleMode != t && (this._nodeInfo.root.scaleX *= 1 / e.x,
                this._nodeInfo.root.scaleY *= 1 / e.y,
                this._scaleMode = t)
            }
            ,
            t
        }(l);
        o.DyncScaleSmall = f;
        var h = function(e) {
            function t() {
                var t = null !== e && e.apply(this, arguments) || this;
                return t._spts = new Map,
                t
            }
            return i(t, e),
            t.prototype.initParams = function() {
                for (var e = 0, t = this._nodeInfo.root.children; e < t.length; e++) {
                    var o = t[e];
                    this._spts.set(o.name, o.getComponent(cc.Sprite).spriteFrame)
                }
                this._nodeInfo.root.active = !1
            }
            ,
            t.prototype.resetParams = function(e, t) {
                e.getComponent(cc.Sprite).spriteFrame = this._spts.get(t || e.name)
            }
            ,
            t.prototype.isReset = function() {
                return !0
            }
            ,
            t
        }(l);
        o.DyncSetSprite = h;
        var d = function(e) {
            function t() {
                return null !== e && e.apply(this, arguments) || this
            }
            return i(t, e),
            t.prototype.resetParams = function(e) {
                this._nodeInfo.root.setParent(e),
                this._nodeInfo.root.setPosition(r.ConstDefine.vec3ZERO)
            }
            ,
            t
        }(l);
        o.DyncSetParent = d;
        var u = function() {
            function e(e) {
                e && this.init(e)
            }
            return e.prototype.init = function(e, t) {
                this._root = e,
                this._root.active = !1,
                this._spt = e.getComponent(cc.Sprite),
                this._resName = t || this._root.name
            }
            ,
            e.prototype.start = function() {
                var e = this;
                this._root.active = !0,
                c.default.getResInfo(this._resName).then(function(t) {
                    !t && cc.error("\u83b7\u53d6\u8d44\u6e90\u5931\u8d25", e._resName),
                    e._spt.spriteFrame = t.asset
                })
            }
            ,
            e.prototype.end = function() {
                this._root && this._root.active && (this._root.active = !1,
                this._spt.spriteFrame = null,
                c.default.hide(this._resName))
            }
            ,
            e.prototype.isShow = function() {
                return this._root.active
            }
            ,
            e.prototype.playAnim = function() {
                this._root.getComponent(cc.Animation).play()
            }
            ,
            e.prototype.setName = function(e) {
                this._resName = e
            }
            ,
            e
        }();
        o.DyncLangSprite = u;
        var p = function() {
            function e(e) {
                this._initPos = e || r.ConstDefine.vec2ZERO
            }
            return Object.defineProperty(e.prototype, "root", {
                get: function() {
                    return this._root
                },
                enumerable: !1,
                configurable: !0
            }),
            e.prototype.start = function(e, t, o) {
                var n = this;
                c.default.getResInfo(e).then(function(e) {
                    e && (n._res = e.asset,
                    n._root = cc.instantiate(e.asset),
                    n._root.setParent(t),
                    n._root.setPosition(n._initPos),
                    o && o(n.root))
                })
            }
            ,
            e.prototype.end = function() {
                this._root && (this._root.destroy(),
                this._root = null,
                c.default.hide(this._res.name))
            }
            ,
            e
        }();
        o.DyncLangNode = p,
        cc._RF.pop()
    }
    , {
        "../LogicMgr": "LogicMgr",
        "../ScreenMgr": "ScreenMgr",
        "../SoundMgr": "SoundMgr",
        "./DyncMgr": "DyncMgr"
    }],
    DyncMgr: [function(e, t, o) {
        "use strict";
        cc._RF.push(t, "bca0adhH1BHXo2Y/BC5zVsN", "DyncMgr"),
        Object.defineProperty(o, "__esModule", {
            value: !0
        });
        var n = e("../../my/config/MutabResCfg")
          , i = e("../common/BufferPool")
          , r = e("../common/Func")
          , a = e("../common/MessageMgr")
          , s = e("../../my/config/Config")
          , c = e("../SoundMgr")
          , l = e("./DyncInfo")
          , f = e("./ResCfg")
          , h = e("../common/SpecialFunc")
          , d = function() {
            function e() {
                this.timeoutHandle = -1
            }
            return e.prototype.init = function(e, t, o) {
                this.resInfo = t,
                this.arg1 = o,
                this.reset(e)
            }
            ,
            e.prototype.reset = function(e) {
                var t = this;
                this.clear(),
                this.timeoutHandle = setTimeout(function() {
                    t.resInfo.destroy(t.arg1),
                    e(t)
                }, 3e4)
            }
            ,
            e.prototype.clear = function() {
                clearInterval(this.timeoutHandle)
            }
            ,
            e
        }()
          , u = function() {
            function e() {}
            return Object.defineProperty(e, "bundles", {
                get: function() {
                    return this._bundles
                },
                enumerable: !1,
                configurable: !0
            }),
            Object.defineProperty(e, "resInfoMap", {
                get: function() {
                    return this._resInfoMap
                },
                enumerable: !1,
                configurable: !0
            }),
            e.init = function() {
                var t = this
                  , o = 0
                  , i = function(i) {
                    var c = s.Config.dyncBundleUrl[i];
                    cc.assetManager.loadBundle(c.url, {
                        version: c.version
                    }, function(d, u) {
                        if (d)
                            console.error("\u83b7\u53d6\u52a8\u6001\u8d44\u6e90bundle\u51fa\u9519", c.url);
                        else if (t._bundles[i] = u,
                        ++o >= s.Config.dyncBundleUrl.length) {
                            for (var p in r.default.mergeJSON(s.Config.dyncResCfg, n.DyncResCfg),
                            n.DyncResCfg) {
                                var g = n.DyncResCfg[p]
                                  , _ = null;
                                switch (g.type) {
                                case f.DyncInfoType.singleNode:
                                    _ = new l.SingleNodeInfo(g,p);
                                    break;
                                case f.DyncInfoType.mulNode:
                                    _ = new l.MulNodeInfo(g,p);
                                    break;
                                default:
                                    _ = new l.DyncResInfo(g,p)
                                }
                                t._resInfoMap.set(p, _)
                            }
                            t.preloadRes(),
                            a.MessageMgr.emit(a.MessageName.LoadDyncResFinish),
                            h.default.isRotateDev() || e.getResInfo("pcFullScreenUI")
                        }
                    })
                };
                for (var c in s.Config.dyncBundleUrl)
                    i(c)
            }
            ,
            e.preloadRes = function() {
                var e = this;
                this._resInfoMap.forEach(function(t) {
                    t.cfg.preLoad && (e._bundles[t.cfg.loadIndex].load(t.cfg.path),
                    t.cfg.preLoad = null)
                })
            }
            ,
            e.getResByClick = function(e) {
                for (var t = this, o = [], n = 1; n < arguments.length; n++)
                    o[n - 1] = arguments[n];
                return new Promise(function(n) {
                    c.default.playEffect("anniu"),
                    n(t.getResInfo(e, o))
                }
                )
            }
            ,
            e.getResInfo = function(e) {
                for (var t = this, o = [], n = 1; n < arguments.length; n++)
                    o[n - 1] = arguments[n];
                return new Promise(function(n) {
                    var i = t._resInfoMap.get(e);
                    !i && cc.error("\u6ca1\u6709\u8fd9\u6837\u7684\u8d44\u6e90\u540d", e),
                    i.canShow = !0;
                    var r = t._waitForPoolMgr.using
                      , a = r.findIndex(function(e) {
                        return e.resInfo === i
                    });
                    a >= 0 && (r[a].clear(),
                    t._waitForPoolMgr.fastRecycleByIndex(a)),
                    n(i.load.apply(i, o))
                }
                )
            }
            ,
            e.hide = function(e, t) {
                var o = this._resInfoMap.get(e);
                if (console.assert(null !== o, "\u9690\u85cf\u8d44\u6e90\u540d\u5b57\u65e0\u6548", e),
                null !== o.asset) {
                    switch (o.cfg.resMode) {
                    case f.DyncResMode.Once:
                        o.destroy(t);
                        break;
                    case f.DyncResMode.Controlled:
                        break;
                    case f.DyncResMode.Destroy:
                        o.destroy(t),
                        this._resInfoMap.delete(e);
                        break;
                    case f.DyncResMode.Wait:
                        o.clear(t);
                        var n = this._waitForPoolMgr.using
                          , i = n.findIndex(function(e) {
                            return e.resInfo === o && e.arg1 === t
                        })
                          , r = this._waitForPoolMgr.recycle.bind(this._waitForPoolMgr);
                        i >= 0 ? n[i].reset(r) : this._waitForPoolMgr.allocate().init(r, o, t);
                        break;
                    default:
                        o.clear(t)
                    }
                    o.canShow = !1
                } else
                    o.canShow && setTimeout(this.hide.bind(this), 2e3, e)
            }
            ,
            e.isLoad = function(e) {
                return this._resInfoMap.get(e).canShow
            }
            ,
            e._bundles = [],
            e._resInfoMap = new Map,
            e._waitForPoolMgr = new i.BufferPool(function() {
                return new d
            }
            ),
            e
        }();
        o.default = u,
        cc._RF.pop()
    }
    , {
        "../../my/config/Config": "Config",
        "../../my/config/MutabResCfg": "MutabResCfg",
        "../SoundMgr": "SoundMgr",
        "../common/BufferPool": "BufferPool",
        "../common/Func": "Func",
        "../common/MessageMgr": "MessageMgr",
        "../common/SpecialFunc": "SpecialFunc",
        "./DyncInfo": "DyncInfo",
        "./ResCfg": "ResCfg"
    }],
    EEvent: [function(e, t, o) {
        "use strict";
        cc._RF.push(t, "c1642sE+YpBNYrM3N0vO5pS", "EEvent"),
        Object.defineProperty(o, "__esModule", {
            value: !0
        }),
        o.Cmd = o.EEvent = void 0,
        o.EEvent = {
            NetMsg: 1,
            Login: 5,
            SwitchProgress: 16,
            P2G: 23,
            G2P: 24,
            Exception: 25,
            Game3rdNet: 27,
            HandShaked: 30,
            NetWorkSate: 31,
            login: 32,
            login2: 33,
            AskSync: 34,
            Sync: 35,
            Shot: 36,
            ShotFish: 37,
            KillFish: 38,
            FinishShot: 39,
            RoomBroadCast: 42,
            ToSelf: 43,
            PlayerOnLine: 44,
            LeaveTable: 45,
            FrameDrive: 46,
            AdjustCredit: 47,
            DebugSuanfa: 48,
            DebugMode: 49,
            KickAll: 50,
            ClearCreditBuff: 51,
            OnShot: 52,
            MakeSureSync: 53,
            UpdateShotTypeState: 54,
            HeartBeat: 55,
            BroadCastTip: 80,
            RqRechargeRes: 82,
            RqGameTimeTag: 83,
            StartGame: 101,
            EndGame: 102
        },
        o.Cmd = {
            MDM_MB_LOGON: 100,
            SUB_MB_LOGON_WEBSOCKET: 6,
            SUB_MB_LOGON_USERINFO: 12,
            SUB_MB_LOGON_USERINFO_REP: 132,
            SUB_MB_LOGON_RESULT: 116,
            SUB_MB_LOGON_GUEST: 13,
            SUB_MB_LOGON_GUEST_REP: 133,
            SUB_MB_LOGON_GUEST_INFO: 14,
            SUB_MB_LOGON_CHANGEPASSWORD: 7,
            SUB_MB_CHANGEPASSWORD_RESULT: 117,
            SUB_MB_LOGON_GETRANKITEM: 8,
            SUB_MB_GETITEMRANK_RESULT: 118,
            SUB_MB_LOGON_GETJPRECORD: 9,
            SUB_MB_GETJPRECORD_RESULT: 119,
            SUB_MB_LOGON_GETJPSCORE: 10,
            SUB_MB_GETJPSCORE_RESULT: 120,
            SUB_MB_LOGON_GETGAMESERVER: 11,
            SUB_MB_GETGAMESERVER_RESULT: 122,
            SUB_MB_LOGON_CHOUJIANG: 16,
            SUB_MB_LOGON_CHOUJIANG_RESULT: 131,
            SUB_MB_MOD_NICKNAME: 17,
            SUB_MB_MOD_NICKNAME_RESULT: 134,
            MDM_GR_GAME: 1,
            SUB_GR_GAME_WEBSOCKET: 4,
            SUB_GR_GAME_RESULT: 104,
            SUB_GR_GAME_PING: 5,
            SUB_GR_GAME_PINGRESULT: 105,
            SUB_GR_GAME_GETJPSCORE: 6,
            SUB_GR_GAME_GETJPSCORE_RESULT: 106,
            SUB_GR_GAME_GETJPRECORD: 7,
            SUB_GR_GAME_GETJPRECORD_RESULT: 107,
            SUB_GR_GAME_JPRECHARGE_RESULT: 108,
            SUB_GR_GAME_MSG_RESULT: 110,
            SUB_GR_GAME_RECHARGE: 8,
            SUB_GR_GAME_RECHARGE_RESULT: 109,
            SUB_MB_LOGON_USERINFO2: 26,
            SUB_MB_LOGON_USERINFO_REP2: 142,
            SUB_GET_HAPPY_WEEK: 27,
            SUB_GET_HAPPY_WEEK_RESULT: 143,
            SUB_GET_CASH_BACK: 28,
            SUB_GET_CASH_BACK_RESULT: 144,
            SUB_GET_FUDAI: 29,
            SUB_GET_FUDAI_RESULT: 145,
            MDM_GR_MAINGAME: 200,
            MDM_GR_SUBGAME: 100
        },
        cc._RF.pop()
    }
    , {}],
    EditboxDisplay: [function(e, t, o) {
        "use strict";
        cc._RF.push(t, "44a3eVl3FJMap+0srHAP39h", "EditboxDisplay");
        var n, i = this && this.__extends || (n = function(e, t) {
            return (n = Object.setPrototypeOf || {
                __proto__: []
            }instanceof Array && function(e, t) {
                e.__proto__ = t
            }
            || function(e, t) {
                for (var o in t)
                    Object.prototype.hasOwnProperty.call(t, o) && (e[o] = t[o])
            }
            )(e, t)
        }
        ,
        function(e, t) {
            function o() {
                this.constructor = e
            }
            n(e, t),
            e.prototype = null === t ? Object.create(t) : (o.prototype = t.prototype,
            new o)
        }
        );
        Object.defineProperty(o, "__esModule", {
            value: !0
        });
        var r = function(e) {
            function t() {
                return null !== e && e.apply(this, arguments) || this
            }
            return i(t, e),
            t.prototype.onLoad = function() {}
            ,
            t
        }(cc.Component);
        o.default = r,
        cc._RF.pop()
    }
    , {}],
    EffectBase: [function(e, t, o) {
        "use strict";
        cc._RF.push(t, "351eeA3+B1MhLBbeQvogia5", "EffectBase");
        var n, i = this && this.__extends || (n = function(e, t) {
            return (n = Object.setPrototypeOf || {
                __proto__: []
            }instanceof Array && function(e, t) {
                e.__proto__ = t
            }
            || function(e, t) {
                for (var o in t)
                    Object.prototype.hasOwnProperty.call(t, o) && (e[o] = t[o])
            }
            )(e, t)
        }
        ,
        function(e, t) {
            function o() {
                this.constructor = e
            }
            n(e, t),
            e.prototype = null === t ? Object.create(t) : (o.prototype = t.prototype,
            new o)
        }
        );
        Object.defineProperty(o, "__esModule", {
            value: !0
        }),
        o.LightFlashes = o.EffectMeetCondition = void 0;
        var r = e("../ScreenMgr")
          , a = function() {
            function e(e) {
                this._state = 0,
                this._timer = 0,
                this.cfg = e,
                this._scaleMode = r.ScreenMode.fitScreen
            }
            return e.prototype.init = function() {
                for (var e = [], t = 0; t < arguments.length; t++)
                    e[t] = arguments[t];
                this._state = 1,
                this.setScaleMode(r.default.Instance.curScale, r.default.Instance.screenMode)
            }
            ,
            e.prototype.update = function() {}
            ,
            e.prototype.setState = function(e, t) {
                void 0 === t && (t = 0),
                this._state = e,
                this._timer = t
            }
            ,
            e.prototype.setScaleMode = function(e, t) {
                this.cfg.node && this._scaleMode != t && this._root && (this._root.scaleX *= 1 / e.x,
                this._root.scaleY *= 1 / e.y,
                this._scaleMode = t)
            }
            ,
            e.prototype.onPlayerLine = function() {}
            ,
            e.prototype.isEnd = function() {
                return !this._state
            }
            ,
            e.prototype.onEnd = function() {
                this._state = 0
            }
            ,
            e.prototype.forceStop = function() {
                this.onEnd()
            }
            ,
            e
        }();
        o.default = a;
        var s = function(e) {
            function t(t) {
                return e.call(this, t) || this
            }
            return i(t, e),
            t.prototype.init = function(t, o, n) {
                e.prototype.init.call(this),
                this._timer = 0,
                this._interval = t,
                this._judgeCallFunc = o,
                this._executeCallFunc = n
            }
            ,
            t.prototype.update = function(e) {
                for (this._timer += e; this._timer > this._interval; ) {
                    if (this._judgeCallFunc())
                        return this._executeCallFunc(),
                        void this.onEnd();
                    this._timer -= this._interval
                }
            }
            ,
            t
        }(a);
        o.EffectMeetCondition = s;
        var c = function(e) {
            function t() {
                return null !== e && e.apply(this, arguments) || this
            }
            return i(t, e),
            t.prototype.init = function(e) {
                this._timer = 0,
                this._normalNode = e.children[0],
                this._normalNode.active = !0,
                this._normalNode.opacity = 255,
                this._opacityNode = e.children[1],
                this._opacityNode.active = !0,
                this._opacityNode.opacity = 0
            }
            ,
            t.prototype.update = function(e) {
                this._timer += e,
                this._timer
            }
            ,
            t
        }(a);
        o.LightFlashes = c,
        cc._RF.pop()
    }
    , {
        "../ScreenMgr": "ScreenMgr"
    }],
    EffectCfg: [function(e, t, o) {
        "use strict";
        cc._RF.push(t, "a4963U6GyRJ/bkdam3Ko6vq", "EffectCfg"),
        Object.defineProperty(o, "__esModule", {
            value: !0
        }),
        o.EffectCfg = void 0;
        var n = e("../../my/config/MutabEffectCfg")
          , i = e("../common/Func")
          , r = e("../common/MessageMgr")
          , a = e("../../my/config/Config")
          , s = e("./EffectBase")
          , c = e("./EffectShake");
        o.EffectCfg = {
            varCfg: {
                type: {
                    EffectShake: {
                        bufferNum: 5,
                        class: c.default
                    },
                    EffectMeetCondition: {
                        bufferNum: 5,
                        class: s.EffectMeetCondition
                    }
                }
            }
        },
        r.MessageMgr.once(r.MessageName.LoadDyncResFinish, function() {
            i.default.coverCfgFunc(o.EffectCfg.varCfg, n.MutabEffectCfg, a.Config.effectCfg)
        }),
        cc._RF.pop()
    }
    , {
        "../../my/config/Config": "Config",
        "../../my/config/MutabEffectCfg": "MutabEffectCfg",
        "../common/Func": "Func",
        "../common/MessageMgr": "MessageMgr",
        "./EffectBase": "EffectBase",
        "./EffectShake": "EffectShake"
    }],
    EffectMgr: [function(e, t, o) {
        "use strict";
        cc._RF.push(t, "39fad/CWOxAUYI2P+yicO18", "EffectMgr");
        var n, i = this && this.__extends || (n = function(e, t) {
            return (n = Object.setPrototypeOf || {
                __proto__: []
            }instanceof Array && function(e, t) {
                e.__proto__ = t
            }
            || function(e, t) {
                for (var o in t)
                    Object.prototype.hasOwnProperty.call(t, o) && (e[o] = t[o])
            }
            )(e, t)
        }
        ,
        function(e, t) {
            function o() {
                this.constructor = e
            }
            n(e, t),
            e.prototype = null === t ? Object.create(t) : (o.prototype = t.prototype,
            new o)
        }
        ), r = this && this.__decorate || function(e, t, o, n) {
            var i, r = arguments.length, a = r < 3 ? t : null === n ? n = Object.getOwnPropertyDescriptor(t, o) : n;
            if ("object" == typeof Reflect && "function" == typeof Reflect.decorate)
                a = Reflect.decorate(e, t, o, n);
            else
                for (var s = e.length - 1; s >= 0; s--)
                    (i = e[s]) && (a = (r < 3 ? i(a) : r > 3 ? i(t, o, a) : i(t, o)) || a);
            return r > 3 && a && Object.defineProperty(t, o, a),
            a
        }
        ;
        Object.defineProperty(o, "__esModule", {
            value: !0
        }),
        o.EffectMgr = void 0;
        var a = e("../common/MessageMgr")
          , s = e("./EffectCfg")
          , c = cc._decorator.ccclass
          , l = function(e) {
            function t() {
                var t = null !== e && e.apply(this, arguments) || this;
                return t._materials = Object.create(null),
                t._effectUsing = [],
                t._effectBuffer = Object.create(null),
                t
            }
            var o;
            return i(t, e),
            o = t,
            t.prototype.onLoad = function() {
                var e = this;
                o.Instance = this,
                a.MessageMgr.on(a.MessageName.SetScaleMode, this.setEffectScale, this),
                a.MessageMgr.once(a.MessageName.LoadCfgFinish, function() {
                    var t = s.EffectCfg.varCfg.type;
                    for (var n in t) {
                        var i = t[n];
                        i.name = n,
                        void 0 === i.bufferNum && (i.bufferNum = 0);
                        for (var r = [], a = 0; a < i.bufferNum; a++)
                            r.push(e.create(i));
                        e._effectBuffer[i.name] = r
                    }
                    o.EffectType = t,
                    s.EffectCfg.varCfg.type = null
                })
            }
            ,
            t.prototype.init = function() {
                for (var e = this._effectUsing.length - 1; e >= 0; e--) {
                    var t = this._effectUsing[e];
                    t.forceStop(),
                    this._effectBuffer[t.cfg.name].push(t),
                    cc.js.array.fastRemoveAt(this._effectUsing, e)
                }
            }
            ,
            t.prototype.getMaterial = function(e) {
                return this._materials[e]
            }
            ,
            t.prototype.update = function(e) {
                for (var t = this._effectUsing.length - 1; t >= 0; t--) {
                    var o = this._effectUsing[t];
                    o.update(e),
                    o.isEnd() && (this._effectBuffer[o.cfg.name].push(o),
                    cc.js.array.fastRemoveAt(this._effectUsing, t))
                }
            }
            ,
            t.prototype.trigger = function(e) {
                for (var t = [], o = 1; o < arguments.length; o++)
                    t[o - 1] = arguments[o];
                var n = this.getEffect(e);
                return n.init.apply(n, t),
                this._effectUsing[this._effectUsing.length] = n,
                n
            }
            ,
            t.prototype.removeEffect = function(e) {
                var t = this._effectUsing.indexOf(e);
                t >= 0 && (this._effectBuffer[e.cfg.name].push(e),
                cc.js.array.fastRemoveAt(this._effectUsing, t))
            }
            ,
            t.prototype.getEffect = function(e) {
                if (null == e)
                    return null;
                var t = this._effectBuffer[e.name];
                return t.length > 0 ? t.pop() : this.create(e)
            }
            ,
            t.prototype.create = function(e) {
                return new e.class(e)
            }
            ,
            t.prototype.setEffectScale = function(e, t) {
                for (var o in this._effectBuffer)
                    for (var n = 0, i = this._effectBuffer[o]; n < i.length; n++)
                        i[n].setScaleMode(e, t);
                for (var r = 0, a = this._effectUsing; r < a.length; r++)
                    a[r].setScaleMode(e, t)
            }
            ,
            t.Instance = null,
            t.EffectType = null,
            o = r([c], t)
        }(cc.Component);
        o.EffectMgr = l,
        cc._RF.pop()
    }
    , {
        "../common/MessageMgr": "MessageMgr",
        "./EffectCfg": "EffectCfg"
    }],
    EffectShake: [function(e, t, o) {
        "use strict";
        cc._RF.push(t, "5f7feNq0e5L7Y8BKn0rlVAg", "EffectShake");
        var n, i = this && this.__extends || (n = function(e, t) {
            return (n = Object.setPrototypeOf || {
                __proto__: []
            }instanceof Array && function(e, t) {
                e.__proto__ = t
            }
            || function(e, t) {
                for (var o in t)
                    Object.prototype.hasOwnProperty.call(t, o) && (e[o] = t[o])
            }
            )(e, t)
        }
        ,
        function(e, t) {
            function o() {
                this.constructor = e
            }
            n(e, t),
            e.prototype = null === t ? Object.create(t) : (o.prototype = t.prototype,
            new o)
        }
        );
        Object.defineProperty(o, "__esModule", {
            value: !0
        });
        var r = e("../common/Func")
          , a = function(e) {
            function t(t) {
                var o = e.call(this, t) || this;
                return o._range = [],
                o._interval = [],
                o._shakeTime = [],
                o._initPos = cc.Vec2.ZERO,
                o
            }
            return i(t, e),
            t.getShakingIndex = function(e) {
                return t.Shaking.findIndex(function(t) {
                    return t.root === e
                })
            }
            ,
            t.getShakingData = function(e) {
                return t.Shaking.find(function(t) {
                    return t.root === e
                })
            }
            ,
            t.removeShakingData = function(e) {
                cc.js.array.fastRemoveAt(t.Shaking, t.getShakingIndex(e))
            }
            ,
            t.prototype.init = function(o, n, i, r, a) {
                void 0 === r && (r = 5),
                void 0 === a && (a = .05);
                var s = t.getShakingData(n);
                if (s) {
                    var c = s.data;
                    c._shakeTime.push(i),
                    c._shakeTime.sort(function(e, t) {
                        return e - t
                    });
                    var l = c._shakeTime.indexOf(i);
                    c._range.splice(l, 0, r),
                    c._interval.splice(l, 0, a),
                    this.onEnd()
                } else
                    t.Shaking.push({
                        data: this,
                        root: n
                    }),
                    e.prototype.init.call(this),
                    this._root = n,
                    this._initPos.set(o),
                    this._timer = 0,
                    this._shakeTime = [],
                    this._range = [],
                    this._interval = [],
                    this._shakeTime.push(i),
                    this._range.push(r),
                    this._interval.push(a)
            }
            ,
            t.prototype.update = function(e) {
                if (0 != this._shakeTime.length) {
                    for (var o = 0; o < this._shakeTime.length; o++)
                        this._shakeTime[o] -= e,
                        this._shakeTime[o] <= 0 && (this._shakeTime.splice(o, 1),
                        this._range.splice(o, 1),
                        this._interval.splice(o, 1),
                        o--);
                    if (0 == this._shakeTime.length)
                        return this._root.setPosition(this._initPos),
                        t.removeShakingData(this._root),
                        void this.onEnd();
                    var n = Math.min.apply(Math, this._interval)
                      , i = Math.max.apply(Math, this._range);
                    this._timer += e,
                    this._timer > n && (this._timer -= n,
                    this._root.x = this._initPos.x + r.default.randomNum(-i, i),
                    this._root.y = this._initPos.y + r.default.randomNum(-i, i))
                }
            }
            ,
            t.prototype.forceStop = function() {
                r.default.clearArray(t.Shaking)
            }
            ,
            t.Shaking = [],
            t
        }(e("./EffectBase").default);
        o.default = a,
        cc._RF.pop()
    }
    , {
        "../common/Func": "Func",
        "./EffectBase": "EffectBase"
    }],
    Effect_Circular_Bead: [function(e, t, o) {
        "use strict";
        cc._RF.push(t, "685e9UtOaFJfJXvjoR5hMca", "Effect_Circular_Bead");
        var n, i = this && this.__extends || (n = function(e, t) {
            return (n = Object.setPrototypeOf || {
                __proto__: []
            }instanceof Array && function(e, t) {
                e.__proto__ = t
            }
            || function(e, t) {
                for (var o in t)
                    Object.prototype.hasOwnProperty.call(t, o) && (e[o] = t[o])
            }
            )(e, t)
        }
        ,
        function(e, t) {
            function o() {
                this.constructor = e
            }
            n(e, t),
            e.prototype = null === t ? Object.create(t) : (o.prototype = t.prototype,
            new o)
        }
        ), r = this && this.__decorate || function(e, t, o, n) {
            var i, r = arguments.length, a = r < 3 ? t : null === n ? n = Object.getOwnPropertyDescriptor(t, o) : n;
            if ("object" == typeof Reflect && "function" == typeof Reflect.decorate)
                a = Reflect.decorate(e, t, o, n);
            else
                for (var s = e.length - 1; s >= 0; s--)
                    (i = e[s]) && (a = (r < 3 ? i(a) : r > 3 ? i(t, o, a) : i(t, o)) || a);
            return r > 3 && a && Object.defineProperty(t, o, a),
            a
        }
        ;
        Object.defineProperty(o, "__esModule", {
            value: !0
        });
        var a = cc._decorator
          , s = a.ccclass
          , c = a.property
          , l = function(e) {
            function t() {
                var t = null !== e && e.apply(this, arguments) || this;
                return t._wRadius = .4,
                t._hRadius = .4,
                t
            }
            return i(t, e),
            Object.defineProperty(t.prototype, "wRadius", {
                get: function() {
                    return this._wRadius
                },
                set: function(e) {
                    this._wRadius = e,
                    this.refreshMaterial()
                },
                enumerable: !1,
                configurable: !0
            }),
            Object.defineProperty(t.prototype, "hRadius", {
                get: function() {
                    return this._hRadius
                },
                set: function(e) {
                    this._hRadius = e,
                    this.refreshMaterial()
                },
                enumerable: !1,
                configurable: !0
            }),
            t.prototype.start = function() {
                this.refreshMaterial()
            }
            ,
            t.prototype.refreshMaterial = function() {
                var e = this.getComponent(cc.Sprite)
                  , t = e.getMaterial(0);
                t && "circular_bead" == t.effectAsset.name && (null != this.wRadius && t.setProperty("w_radius", this.wRadius),
                null != this.hRadius && t.setProperty("h_radius", this.hRadius),
                e.setMaterial(0, t))
            }
            ,
            r([c], t.prototype, "_wRadius", void 0),
            r([c], t.prototype, "wRadius", null),
            r([c], t.prototype, "_hRadius", void 0),
            r([c], t.prototype, "hRadius", null),
            r([s], t)
        }(cc.Component);
        o.default = l,
        cc._RF.pop()
    }
    , {}],
    Effect_Dibble: [function(e, t, o) {
        "use strict";
        cc._RF.push(t, "62aa2GvWBxNWLXVZJfmretd", "Effect_Dibble");
        var n, i = this && this.__extends || (n = function(e, t) {
            return (n = Object.setPrototypeOf || {
                __proto__: []
            }instanceof Array && function(e, t) {
                e.__proto__ = t
            }
            || function(e, t) {
                for (var o in t)
                    Object.prototype.hasOwnProperty.call(t, o) && (e[o] = t[o])
            }
            )(e, t)
        }
        ,
        function(e, t) {
            function o() {
                this.constructor = e
            }
            n(e, t),
            e.prototype = null === t ? Object.create(t) : (o.prototype = t.prototype,
            new o)
        }
        ), r = this && this.__decorate || function(e, t, o, n) {
            var i, r = arguments.length, a = r < 3 ? t : null === n ? n = Object.getOwnPropertyDescriptor(t, o) : n;
            if ("object" == typeof Reflect && "function" == typeof Reflect.decorate)
                a = Reflect.decorate(e, t, o, n);
            else
                for (var s = e.length - 1; s >= 0; s--)
                    (i = e[s]) && (a = (r < 3 ? i(a) : r > 3 ? i(t, o, a) : i(t, o)) || a);
            return r > 3 && a && Object.defineProperty(t, o, a),
            a
        }
        ;
        Object.defineProperty(o, "__esModule", {
            value: !0
        });
        var a = cc._decorator
          , s = a.ccclass
          , c = a.property
          , l = function(e) {
            function t() {
                var t = null !== e && e.apply(this, arguments) || this;
                return t._hole0 = null,
                t._hole1 = null,
                t._round0 = -1,
                t._round1 = -1,
                t._direction = -1,
                t
            }
            return i(t, e),
            Object.defineProperty(t.prototype, "hole0", {
                get: function() {
                    return this._hole0
                },
                set: function(e) {
                    this._hole0 = e,
                    this.refreshMaterial()
                },
                enumerable: !1,
                configurable: !0
            }),
            Object.defineProperty(t.prototype, "hole1", {
                get: function() {
                    return this._hole1
                },
                set: function(e) {
                    this._hole1 = e,
                    this.refreshMaterial()
                },
                enumerable: !1,
                configurable: !0
            }),
            Object.defineProperty(t.prototype, "round0", {
                get: function() {
                    return this._round0
                },
                set: function(e) {
                    this._round0 = e,
                    this.refreshMaterial()
                },
                enumerable: !1,
                configurable: !0
            }),
            Object.defineProperty(t.prototype, "round1", {
                get: function() {
                    return this._round1
                },
                set: function(e) {
                    this._round1 = e,
                    this.refreshMaterial()
                },
                enumerable: !1,
                configurable: !0
            }),
            Object.defineProperty(t.prototype, "direction", {
                get: function() {
                    return this._direction
                },
                set: function(e) {
                    this._direction = e,
                    this.refreshMaterial()
                },
                enumerable: !1,
                configurable: !0
            }),
            t.prototype.start = function() {
                this.refreshMaterial()
            }
            ,
            t.prototype.refreshMaterial = function() {
                var e = this.getComponent(cc.Sprite)
                  , t = (e = this.node.getComponent(cc.Sprite)).getMaterial(0);
                t && "Effect_Dibble" == t.effectAsset.name && (t.setProperty("u_tex_size", [this.node.width, this.node.height]),
                null != this.hole0 && t.setProperty("u_hole0_lrbt", [this.hole0.x, this.hole0.y, this.hole0.z, this.hole0.w]),
                null != this.hole1 && t.setProperty("u_hole1_lrbt", [this.hole1.x, this.hole1.y, this.hole1.z, this.hole1.w]),
                null != this.direction && t.setProperty("u_direction", this.direction),
                null != this.round0 && t.setProperty("u_round0", this.round0),
                null != this.round1 && t.setProperty("u_round1", this.round1),
                e.setMaterial(0, t))
            }
            ,
            r([c(cc.Vec4)], t.prototype, "_hole0", void 0),
            r([c(cc.Vec4)], t.prototype, "hole0", null),
            r([c(cc.Vec4)], t.prototype, "_hole1", void 0),
            r([c(cc.Vec4)], t.prototype, "hole1", null),
            r([c], t.prototype, "_round0", void 0),
            r([c], t.prototype, "round0", null),
            r([c], t.prototype, "_round1", void 0),
            r([c], t.prototype, "round1", null),
            r([c], t.prototype, "_direction", void 0),
            r([c], t.prototype, "direction", null),
            r([s], t)
        }(cc.Component);
        o.default = l,
        cc._RF.pop()
    }
    , {}],
    Func: [function(e, t, o) {
        "use strict";
        cc._RF.push(t, "4dae8NJeWNNLoh/bNs5Qqvn", "Func"),
        Object.defineProperty(o, "__esModule", {
            value: !0
        });
        var n = e("../third/crypto-js/crypto-js")
          , i = cc.Vec2.ZERO
          , r = cc.Vec3.ZERO
          , a = []
          , s = [0, 0]
          , c = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "a", "b", "c", "d", "e", "f", "g"]
          , l = function() {
            function e() {}
            return e.randomNum = function(e, t) {
                return Math.random() * (t - e + 1) + e
            }
            ,
            e.randomInt = function(e, t) {
                return Math.floor(this.randomNum(e, t))
            }
            ,
            e.clearArray = function(e) {
                e.splice(0, e.length)
            }
            ,
            e.addClearArr = function(e, t) {
                e.push.apply(e, t),
                this.clearArray(t)
            }
            ,
            e.isJSON = function(e) {
                return "object" == typeof e && e.constructor == Object
            }
            ,
            e.isArray = function(e) {
                return "[object Array]" == Object.prototype.toString.call(e)
            }
            ,
            e.mergeJSON = function(e, t) {
                if (void 0 !== e)
                    for (var o in e)
                        void 0 !== t[o] && this.isJSON(e[o]) ? this.mergeJSON(e[o], t[o]) : t[o] = e[o]
            }
            ,
            e.coverCfgFunc = function(e, t, o) {
                void 0 !== t && this.mergeJSON(t, e),
                void 0 !== o && this.mergeJSON(o, e)
            }
            ,
            e.mergeJSONOnce = function(e, t) {
                t.once && (this.mergeJSON(e, t),
                t.once = void 0)
            }
            ,
            e.getMergeData = function(e, t) {
                var o = this.deepMerge(t);
                return e && this.mergeJSON(e, o),
                o
            }
            ,
            e.arrayStr2ObjectVal = function(e) {
                for (var t = Object.create(null), o = 0; o < e.length; o++)
                    t[e[o]] = o;
                return t
            }
            ,
            e.arrayStr2ObjectStr = function(e) {
                for (var t = Object.create(null), o = 0; o < e.length; o++)
                    t[e[o]] = e[o];
                return t
            }
            ,
            e.stringToBytes = function(e) {
                var t, o;
                this.clearArray(a),
                t = e.length;
                for (var n = 0; n < t; n++)
                    (o = e.charCodeAt(n)) >= 65536 && o <= 1114111 ? (a[a.length] = o >> 18 & 7 | 240,
                    a[a.length] = o >> 12 & 63 | 128,
                    a[a.length] = o >> 6 & 63 | 128,
                    a[a.length] = 63 & o | 128) : o >= 2048 && o <= 65535 ? (a[a.length] = o >> 12 & 15 | 224,
                    a[a.length] = o >> 6 & 63 | 128,
                    a[a.length] = 63 & o | 128) : o >= 128 && o <= 2047 ? (a[a.length] = o >> 6 & 31 | 192,
                    a[a.length] = 63 & o | 128) : a[a.length] = 255 & o;
                return a
            }
            ,
            e.stringToHex = function(e) {
                for (var t = "", o = 0; o < e.length; o++)
                    "" == t ? t = e.charCodeAt(o).toString(16) : t += e.charCodeAt(o).toString(16);
                return t + "0a"
            }
            ,
            e.timeStr2Second = function(e) {
                if ("" == e)
                    return 0;
                var t = e.match(/\d+/g);
                return 3600 * Number(t[0]) + 60 * Number(t[1]) + Number(t[2])
            }
            ,
            e.second2TimeStr = function(e) {
                var t = Math.floor(e / 3600);
                e %= 3600;
                var o = Math.floor(e / 60)
                  , n = e % 60;
                return String(t).padStart(2, "0") + ":" + String(o).padStart(2, "0") + ":" + String(n).padStart(2, "0")
            }
            ,
            e.hexToString = function(e) {
                for (var t = e.split(""), o = "", n = 0; n < t.length / 2; n++) {
                    var i = "0x" + t[2 * n] + t[2 * n + 1];
                    o += String.fromCharCode(parseInt(i))
                }
                return o
            }
            ,
            e.fillZero = function(e) {
                return e < 10 ? "0" + e : e.toString()
            }
            ,
            e.bytesToString = function(e, t) {
                var o, n, i, r;
                null == t && (t = e.length),
                this.clearArray(a);
                for (var s = 0; s < t; s++)
                    if ((r = (i = e[s].toString(2)).match(/^1+?(?=0)/)) && 8 == i.length) {
                        o = r[0].length,
                        n = e[s].toString(2).slice(7 - o);
                        for (var c = 1; c < o; c++)
                            n += e[c + s].toString(2).slice(2);
                        a[a.length] = parseInt(n, 2),
                        s += o - 1
                    } else
                        a[a.length] = e[s];
                return String.fromCharCode.apply(String, a)
            }
            ,
            e.utf16ToString = function(e, t) {
                this.clearArray(a),
                null == t && (t = e.length);
                for (var o, n, i, r = -1; r < t; )
                    if (o = e[++r],
                    (n = (e[++r] << 8) + o) < 55296 || n >= 57344) {
                        if (0 === n)
                            break;
                        a.push(n)
                    } else
                        n >= 55296 && n < 56320 && r + 2 < t && (o = e[++r],
                        (i = (e[++r] << 8) + o) >= 56320 && i < 57344 && (n &= 16368,
                        n += 1023 & i,
                        a.push(n)));
                return String.fromCharCode.apply(String, a)
            }
            ,
            e.bytesToString2 = function(e) {
                this.clearArray(a);
                for (var t = 0, o = e.length; t < o && 0 != e[t]; t++)
                    a[a.length] = e[t];
                return String.fromCharCode.apply(String, a)
            }
            ,
            e.int16ToBytes = function(e) {
                return this.clearArray(a),
                a[a.length] = e >>> 8 & 255,
                a[a.length] = 255 & e,
                a
            }
            ,
            e.int32ToBytes = function(e) {
                return this.clearArray(a),
                a[a.length] = 255 & e,
                a[a.length] = e >>> 8 & 255,
                a[a.length] = e >>> 16 & 255,
                a[a.length] = e >>> 24 & 255,
                a
            }
            ,
            e.bytesToInt16 = function(e, t) {
                return ((255 & e) << 8) + (255 & t)
            }
            ,
            e.bytesArrToInt32 = function(e, t) {
                return void 0 === t && (t = 0),
                this.bytesToInt32(e[t + 3], e[t + 2], e[t + 1], e[t])
            }
            ,
            e.bytesToInt32 = function(e, t, o, n) {
                return ((255 & e) << 24) + ((255 & t) << 16) + ((255 & o) << 8) + (255 & n)
            }
            ,
            e.vec2ToArr = function(e) {
                return s[0] = e.x,
                s[1] = e.y,
                s
            }
            ,
            e.arrToVec2 = function(e, t) {
                var o = t || i;
                return cc.Vec2.set(o, e[0], e[1]),
                o
            }
            ,
            e.numToVec2 = function(e, t) {
                return cc.Vec2.set(i, e, t)
            }
            ,
            e.encryMd5 = function(e) {
                return n.MD5(e).toString()
            }
            ,
            e.getSignature = function(e, t, o) {
                var n = t + o + e + "RYSyncLoginKey";
                return (n = this.encryMd5(n)).toUpperCase()
            }
            ,
            e.decryptAES = function(e) {
                try {
                    var t = n.enc.Utf8.parse("pbc_efgfi1@l0nwp")
                      , o = n.enc.Utf8.parse("pbc_efgfi1@l0nwp");
                    return n.AES.decrypt({
                        ciphertext: n.enc.Base64.parse(e)
                    }, t, {
                        iv: o,
                        mode: n.mode.CBC,
                        padding: n.pad.Pkcs7
                    }).toString(n.enc.Utf8)
                } catch (i) {
                    return "false"
                }
            }
            ,
            e.customEncry = function(t) {
                var o = e.stringToHex(t);
                t = "";
                for (var n = 0; n < o.length; ++n) {
                    var i = c.indexOf(o[n]);
                    t += c[i + 1]
                }
                return t
            }
            ,
            e.customDecrypt = function(t) {
                for (var o = "", n = 0; n < t.length; ++n) {
                    var i = c.indexOf(t[n]);
                    o += c[i - 1]
                }
                return e.hexToString(o)
            }
            ,
            e.vec2ToVec3 = function(e) {
                return r.x = e.x,
                r.y = e.y,
                r
            }
            ,
            e.vec3ToVec2 = function(e) {
                return i.x = e.x,
                i.y = e.y,
                i
            }
            ,
            e.isMasterSide = function(e, t) {
                return Math.floor(t / 2) == Math.floor(e / 2)
            }
            ,
            e.setState = function(e, t, o) {
                e.tim = o || 0,
                e.state = t
            }
            ,
            e.bytesCopy = function(e, t, o, n, i) {
                for (var r = 0; r < i; ++r)
                    o[n + r] = e[t + r]
            }
            ,
            e.replaceNodeFunc = function(e, t) {
                var o = e.parent
                  , n = e.getSiblingIndex();
                e.destroy(),
                t.parent = o,
                t.setSiblingIndex(n)
            }
            ,
            e.createPosRoot = function(e) {
                var t = new cc.Node;
                return t.parent = e.parent,
                e.parent = t,
                t
            }
            ,
            e.instanceMount = function(e, t) {
                var o = cc.instantiate(e);
                return o.setParent(t),
                o
            }
            ,
            e.Logic2Device = function(e) {
                return i.x = e.x / 1600,
                i.y = e.y / 900,
                i
            }
            ,
            e.GetDeviceZoom = function() {
                return (625e-6 + 1 / 900) / 2
            }
            ,
            e.num2Str = function(e, t) {
                for (var o = e.toString(); o.length < t; )
                    o = "0" + o;
                return o
            }
            ,
            e.change2Time = function(e) {
                var t = e.match(/\d+\/\d+ \d+:\d+/);
                return t ? t[0] : e
            }
            ,
            e.isPlainObject = function(e) {
                return "[object Object]" === toString.call(e)
            }
            ,
            e.removeAllComponents = function(e, t) {
                for (var o = 0, n = e.getComponentsInChildren(t); o < n.length; o++)
                    n[o].destroy()
            }
            ,
            e.nodeZoomIn = function(e, t) {
                e.setScale(0),
                cc.tween(e).to(t, {
                    scale: 1
                }).start()
            }
            ,
            e.deepMerge = function(e) {
                if (null === e || "object" != typeof e)
                    return e;
                var t = e instanceof Array ? [] : {};
                for (var o in e)
                    t[o] = this.deepMerge(e[o]);
                return t
            }
            ,
            e.outPutJson = function(e, t, o) {
                var n, i = this;
                if (void 0 === t && (t = ""),
                void 0 === o && (o = 0),
                "object" == typeof e) {
                    for (var r = "\n", a = "\n", s = 0; s < o; s++)
                        a += "\t",
                        r += "\t";
                    r += "\t",
                    o++,
                    n = a,
                    n += "" == t ? t : '"' + t + '": ';
                    var c = e instanceof Array
                      , l = c ? "]" : "}";
                    n += c ? "[" : "{",
                    c ? e.forEach(function(t, a) {
                        var s = !0;
                        switch (typeof t) {
                        case "object":
                            n += i.outPutJson(t, "", o);
                            break;
                        case "string":
                            n += r + '"' + t + '"';
                            break;
                        case "boolean":
                        case "number":
                            n += r + t;
                            break;
                        default:
                            s = !1
                        }
                        s && a < e.length - 1 && (n += ",")
                    }) : Object.keys(e).forEach(function(t, a, s) {
                        var c = !0
                          , l = e[t];
                        switch (typeof l) {
                        case "object":
                            n += i.outPutJson(l, t, o);
                            break;
                        case "string":
                            n += r + '"' + t + '": "' + l + '"';
                            break;
                        case "boolean":
                        case "number":
                            n += r + '"' + t + '": ' + l;
                            break;
                        default:
                            c = !1
                        }
                        c && a < s.length - 1 && (n += ",")
                    }),
                    n += a + l
                }
                return n
            }
            ,
            e.editboxDisplay = function() {}
            ,
            e.removeLoading = function() {
                var e = document.getElementById("splash");
                e && e.remove()
            }
            ,
            e.getStorage = function(e) {
                return cc.sys.isBrowser ? sessionStorage.getItem(e) : cc.sys.localStorage.getItem(e)
            }
            ,
            e.setStorage = function(e, t) {
                return cc.sys.isBrowser ? sessionStorage.setItem(e, t) : cc.sys.localStorage.setItem(e, t)
            }
            ,
            e.removeStorage = function(e) {
                return cc.sys.isBrowser ? sessionStorage.removeItem(e) : cc.sys.localStorage.removeItem(e)
            }
            ,
            e.isRotateDev = function() {
                return void 0 !== window.orientation
            }
            ,
            e.findRandomIndex = function(t, o) {
                for (var n = t.length, i = e.randomInt(0, n - 1), r = n; r > 0; ) {
                    if (t[i] === o)
                        return i;
                    ++i >= n && (i = 0),
                    --r
                }
                return -1
            }
            ,
            e
        }();
        o.default = l,
        cc._RF.pop()
    }
    , {
        "../third/crypto-js/crypto-js": "crypto-js"
    }],
    GTAssembler2D: [function(e, t, o) {
        "use strict";
        cc._RF.push(t, "71fa4ynABhHIpZvLmu/RcPN", "GTAssembler2D");
        var n, i = this && this.__extends || (n = function(e, t) {
            return (n = Object.setPrototypeOf || {
                __proto__: []
            }instanceof Array && function(e, t) {
                e.__proto__ = t
            }
            || function(e, t) {
                for (var o in t)
                    Object.prototype.hasOwnProperty.call(t, o) && (e[o] = t[o])
            }
            )(e, t)
        }
        ,
        function(e, t) {
            function o() {
                this.constructor = e
            }
            n(e, t),
            e.prototype = null === t ? Object.create(t) : (o.prototype = t.prototype,
            new o)
        }
        );
        Object.defineProperty(o, "__esModule", {
            value: !0
        });
        var r = function(e) {
            function t() {
                var t = null !== e && e.apply(this, arguments) || this;
                return t.verticesCount = 4,
                t.indicesCount = 6,
                t.floatsPerVert = 5,
                t.uvOffset = 2,
                t.colorOffset = 4,
                t._renderData = null,
                t._local = null,
                t
            }
            return i(t, e),
            t.prototype.init = function(t) {
                e.prototype.init.call(this, t),
                this._renderData = new cc.RenderData,
                this._renderData.init(this),
                this.initLocal(),
                this.initData()
            }
            ,
            Object.defineProperty(t.prototype, "verticesFloats", {
                get: function() {
                    return this.verticesCount * this.floatsPerVert
                },
                enumerable: !1,
                configurable: !0
            }),
            t.prototype.initData = function() {
                this._renderData.createQuadData(0, this.verticesFloats, this.indicesCount)
            }
            ,
            t.prototype.initLocal = function() {
                this._local = [],
                this._local.length = 4
            }
            ,
            t.prototype.updateColor = function(e, t) {
                var o = this._renderData.uintVDatas[0];
                if (o) {
                    t = null != t ? t : e.node.color._val;
                    for (var n = this.floatsPerVert, i = this.colorOffset, r = o.length; i < r; i += n)
                        o[i] = t
                }
            }
            ,
            t.prototype.getBuffer = function() {
                return cc.renderer._handle._meshBuffer
            }
            ,
            t.prototype.updateWorldVerts = function(e) {
                this.updateWorldVertsWebGL(e)
            }
            ,
            t.prototype.updateWorldVertsWebGL = function(e) {
                var t = this._local
                  , o = this._renderData.vDatas[0]
                  , n = e.node._worldMatrix.m
                  , i = n[0]
                  , r = n[1]
                  , a = n[4]
                  , s = n[5]
                  , c = n[12]
                  , l = n[13]
                  , f = t[0]
                  , h = t[2]
                  , d = t[1]
                  , u = t[3]
                  , p = 1 === i && 0 === r && 0 === a && 1 === s
                  , g = 0
                  , _ = this.floatsPerVert;
                if (p)
                    o[g] = f + c,
                    o[g + 1] = d + l,
                    o[g += _] = h + c,
                    o[g + 1] = d + l,
                    o[g += _] = f + c,
                    o[g + 1] = u + l,
                    o[g += _] = h + c,
                    o[g + 1] = u + l;
                else {
                    var y = i * f
                      , m = i * h
                      , v = r * f
                      , b = r * h
                      , C = a * d
                      , M = a * u
                      , S = s * d
                      , w = s * u;
                    o[g] = y + C + c,
                    o[g + 1] = v + S + l,
                    o[g += _] = m + C + c,
                    o[g + 1] = b + S + l,
                    o[g += _] = y + M + c,
                    o[g + 1] = v + w + l,
                    o[g += _] = m + M + c,
                    o[g + 1] = b + w + l
                }
            }
            ,
            t.prototype.updateWorldVertsNative = function() {
                var e = this._local
                  , t = this._renderData.vDatas[0]
                  , o = this.floatsPerVert
                  , n = e[0]
                  , i = e[2]
                  , r = e[1]
                  , a = e[3]
                  , s = 0;
                t[s] = n,
                t[s + 1] = r,
                t[s += o] = i,
                t[s + 1] = r,
                t[s += o] = n,
                t[s + 1] = a,
                t[s += o] = i,
                t[s + 1] = a
            }
            ,
            t.prototype.fillBuffers = function(e, t) {
                t.worldMatDirty && this.updateWorldVerts(e);
                var o = this._renderData
                  , n = o.vDatas[0]
                  , i = o.iDatas[0]
                  , r = this.getBuffer()
                  , a = r.request(this.verticesCount, this.indicesCount)
                  , s = a.byteOffset >> 2
                  , c = r._vData;
                n.length + s > c.length ? c.set(n.subarray(0, c.length - s), s) : c.set(n, s);
                for (var l = r._iData, f = a.indiceOffset, h = a.vertexOffset, d = 0, u = i.length; d < u; d++)
                    l[f++] = h + i[d]
            }
            ,
            t.prototype.packToDynamicAtlas = function(e, t) {
                if (!t._original && cc.dynamicAtlasManager && t._texture.packable) {
                    var o = cc.dynamicAtlasManager.insertSpriteFrame(t);
                    o && t._setDynamicAtlasFrame(o)
                }
                var n = e._materials[0];
                n && n.getProperty("texture") !== t._texture && (e._vertsDirty = !0,
                e._updateMaterial())
            }
            ,
            t.prototype.updateUVs = function() {
                for (var e = [0, 0, 1, 0, 0, 1, 1, 1], t = this.uvOffset, o = this.floatsPerVert, n = this._renderData.vDatas[0], i = 0; i < 4; i++) {
                    var r = 2 * i
                      , a = o * i + t;
                    n[a] = e[r],
                    n[a + 1] = e[r + 1]
                }
            }
            ,
            t.prototype.updateVerts = function(e) {
                var t, o, n, i, r = e.node, a = r.width, s = r.height, c = r.anchorX * a, l = r.anchorY * s;
                t = -c,
                o = -l,
                n = a - c,
                i = s - l;
                var f = this._local;
                f[0] = t,
                f[1] = o,
                f[2] = n,
                f[3] = i,
                this.updateWorldVerts(e)
            }
            ,
            t.prototype.updateRenderData = function(e) {
                e._vertsDirty && (this.updateUVs(e),
                this.updateVerts(e),
                e._vertsDirty = !1)
            }
            ,
            t
        }(cc.Assembler);
        o.default = r,
        cc._RF.pop()
    }
    , {}],
    GTAutoFitSpriteAssembler2D: [function(e, t, o) {
        "use strict";
        cc._RF.push(t, "68a18GLvTNCcrf7Bs6SeUi8", "GTAutoFitSpriteAssembler2D");
        var n, i = this && this.__extends || (n = function(e, t) {
            return (n = Object.setPrototypeOf || {
                __proto__: []
            }instanceof Array && function(e, t) {
                e.__proto__ = t
            }
            || function(e, t) {
                for (var o in t)
                    Object.prototype.hasOwnProperty.call(t, o) && (e[o] = t[o])
            }
            )(e, t)
        }
        ,
        function(e, t) {
            function o() {
                this.constructor = e
            }
            n(e, t),
            e.prototype = null === t ? Object.create(t) : (o.prototype = t.prototype,
            new o)
        }
        );
        Object.defineProperty(o, "__esModule", {
            value: !0
        });
        var r = function(e) {
            function t() {
                var t = null !== e && e.apply(this, arguments) || this;
                return t._uv = [],
                t
            }
            return i(t, e),
            t.prototype.updateUVs = function(t) {
                var o = t._spriteFrame.getRect()
                  , n = t.node;
                if (o.width && o.height && n.width && n.height) {
                    Object.assign(this._uv, t._spriteFrame.uv);
                    var i = this._uv
                      , r = o.width / n.width
                      , a = o.height / n.height
                      , s = t._spriteFrame.isRotated()
                      , c = i[0]
                      , l = i[2]
                      , f = i[1]
                      , h = i[5];
                    if (s && (c = i[1],
                    l = i[3],
                    f = i[0],
                    h = i[4]),
                    r > a) {
                        var d = .5 * (c + l)
                          , u = .5 * (l - c) * (a / r);
                        c = i[0 + (p = s ? 1 : 0)] = i[4 + p] = d - u,
                        l = i[2 + p] = i[6 + p] = d + u
                    } else {
                        var p;
                        d = .5 * (f + h),
                        u = .5 * (f - h) * (r / a),
                        f = i[1 + (p = s ? -1 : 0)] = i[3 + p] = d + u,
                        h = i[5 + p] = i[7 + p] = d - u
                    }
                    for (var g = this.uvOffset, _ = this.floatsPerVert, y = this._renderData.vDatas[0], m = 0; m < 4; m++) {
                        var v = 2 * m
                          , b = _ * m + g;
                        y[b] = i[v],
                        y[b + 1] = i[v + 1]
                    }
                } else
                    e.prototype.updateUVs.call(this, t)
            }
            ,
            t
        }(e("./GTSimpleSpriteAssembler2D").default);
        o.default = r,
        cc._RF.pop()
    }
    , {
        "./GTSimpleSpriteAssembler2D": "GTSimpleSpriteAssembler2D"
    }],
    GTSimpleSpriteAssembler2D: [function(e, t, o) {
        "use strict";
        cc._RF.push(t, "66290S7PelKypCVAH1r/Ms6", "GTSimpleSpriteAssembler2D");
        var n, i = this && this.__extends || (n = function(e, t) {
            return (n = Object.setPrototypeOf || {
                __proto__: []
            }instanceof Array && function(e, t) {
                e.__proto__ = t
            }
            || function(e, t) {
                for (var o in t)
                    Object.prototype.hasOwnProperty.call(t, o) && (e[o] = t[o])
            }
            )(e, t)
        }
        ,
        function(e, t) {
            function o() {
                this.constructor = e
            }
            n(e, t),
            e.prototype = null === t ? Object.create(t) : (o.prototype = t.prototype,
            new o)
        }
        );
        Object.defineProperty(o, "__esModule", {
            value: !0
        });
        var r = function(e) {
            function t() {
                return null !== e && e.apply(this, arguments) || this
            }
            return i(t, e),
            t.prototype.updateRenderData = function(t) {
                this.packToDynamicAtlas(t, t._spriteFrame),
                e.prototype.updateRenderData.call(this, t)
            }
            ,
            t.prototype.updateUVs = function(e) {
                for (var t = e._spriteFrame.uv, o = this.uvOffset, n = this.floatsPerVert, i = this._renderData.vDatas[0], r = 0; r < 4; r++) {
                    var a = 2 * r
                      , s = n * r + o;
                    i[s] = t[a],
                    i[s + 1] = t[a + 1]
                }
            }
            ,
            t.prototype.updateVerts = function(e) {
                var t, o, n, i, r = e.node, a = r.width, s = r.height, c = r.anchorX * a, l = r.anchorY * s;
                if (e.trim)
                    t = -c,
                    o = -l,
                    n = a - c,
                    i = s - l;
                else {
                    var f = e.spriteFrame
                      , h = f._originalSize.width
                      , d = f._originalSize.height
                      , u = f._rect.width
                      , p = f._rect.height
                      , g = f._offset
                      , _ = a / h
                      , y = s / d
                      , m = g.x + (h - u) / 2
                      , v = g.x - (h - u) / 2;
                    t = m * _ - c,
                    o = (g.y + (d - p) / 2) * y - l,
                    n = a + v * _ - c,
                    i = s + (g.y - (d - p) / 2) * y - l
                }
                var b = this._local;
                b[0] = t,
                b[1] = o,
                b[2] = n,
                b[3] = i,
                this.updateWorldVerts(e)
            }
            ,
            t
        }(e("./GTAssembler2D").default);
        o.default = r,
        cc._RF.pop()
    }
    , {
        "./GTAssembler2D": "GTAssembler2D"
    }],
    GameNet: [function(e, t, o) {
        "use strict";
        cc._RF.push(t, "22ec1L7J8BPELSWenmSLLak", "GameNet"),
        Object.defineProperty(o, "__esModule", {
            value: !0
        });
        var n = e("../common/Func")
          , i = e("../../my/config/Config")
          , r = e("../res/DyncMgr")
          , a = e("../res/LanguageMgr")
          , s = e("../SoundMgr")
          , c = e("./EEvent")
          , l = e("../LogicMgr")
          , f = function() {
            function e() {}
            return e.startGame = function(e) {
                var t = this;
                l.default.browsePage ? r.default.getResInfo(l.ConstDefine.loginUI) : l.default.login.succeed ? e.address ? (r.default.getResInfo(l.ConstDefine.loadingTip),
                null == this._socket || this._socket.readyState === WebSocket.CLOSED && navigator.onLine || this._socket.close(),
                this._realPort = e.bsPort,
                l.default.login.guestLogin ? this._realAddress = i.Config.gameProtocol + i.Config.demoServerIp : (this._realAddress = i.Config.gameProtocol + e.address,
                void 0 !== i.Config.gameUrl && void 0 !== e.port && (this._realAddress = i.Config.gameUrl,
                this._realPort = e.port)),
                this._socket = new WebSocket(this._realAddress + ":" + this._realPort,i.Config.wsProtocol),
                this._socket.onopen = function() {
                    var e = {
                        mainID: c.Cmd.MDM_GR_GAME,
                        subID: c.Cmd.SUB_GR_GAME_PING,
                        userid: l.default.login.userID,
                        password: l.default.login.dynamicPass
                    };
                    t._socket.send(JSON.stringify(e))
                }
                ,
                this._socket.onclose = this.onClose.bind(this),
                this._socket.onmessage = this.onMessage.bind(this),
                this._socket.onerror = this.onError.bind(this),
                this._curGameCfg = e,
                this._timeOutHandle = setTimeout(function() {
                    r.default.hide(l.ConstDefine.loadingTip),
                    navigator.onLine ? r.default.getResInfo(l.ConstDefine.msgTip, a.default.procLangText("enterGameError")) : r.default.getResInfo(l.ConstDefine.msgTip, a.default.procLangText("badNetStatus")),
                    t._socket.close()
                }, 5e3)) : r.default.getResInfo(l.ConstDefine.msgTip, a.default.procLangText("enterGameError"), 5) : r.default.getResInfo(l.ConstDefine.msgTip, a.default.procLangText("badNetStatus"))
            }
            ,
            e.onMessage = function(e) {
                var t = JSON.parse(e.data)
                  , o = t.data;
                if (t.mainID == c.Cmd.MDM_GR_GAME && t.subID == c.Cmd.SUB_GR_GAME_PINGRESULT) {
                    if (0 == o.result) {
                        var f = {
                            platName: i.Config.platLinkName || i.Config.platName,
                            cback: i.Config.gameCback || window.document.location.href,
                            id: l.default.login.gameID,
                            pwd: l.default.login.pwd,
                            token: l.default.login.dynamicPass,
                            ip: this._realAddress,
                            port: this._realPort,
                            lang: a.default.currLang,
                            testAcc: l.default.login.testAcccount,
                            musicVol: s.default.getBGMVol().toFixed(2),
                            effectVol: s.default.getEffectVol().toFixed(2)
                        }
                          , h = n.default.customEncry(JSON.stringify(f))
                          , d = this._curGameCfg.url + "?params=" + h;
                        d.length > 2083 && console.error("\u8fde\u63a5\u957f\u5ea6\u8d85\u8fc7\u4e862083\u5b57\u7b26"),
                        this._socket.close(),
                        location.href = d
                    } else
                        r.default.hide(l.ConstDefine.loadingTip),
                        r.default.getResInfo(l.ConstDefine.msgTip, a.default.procBsText(o.msg)),
                        this._socket.close();
                    clearTimeout(this._timeOutHandle)
                }
            }
            ,
            e.onError = function(e) {
                cc.error("gameNetError", e)
            }
            ,
            e.onClose = function() {}
            ,
            e._socket = null,
            e
        }();
        o.default = f,
        cc._RF.pop()
    }
    , {
        "../../my/config/Config": "Config",
        "../LogicMgr": "LogicMgr",
        "../SoundMgr": "SoundMgr",
        "../common/Func": "Func",
        "../res/DyncMgr": "DyncMgr",
        "../res/LanguageMgr": "LanguageMgr",
        "./EEvent": "EEvent"
    }],
    GameProto: [function(e, t, o) {
        "use strict";
        cc._RF.push(t, "d01d2fLlENAO439SiI+Y+DM", "GameProto"),
        Object.defineProperty(o, "__esModule", {
            value: !0
        }),
        o.Proto = void 0,
        function(e) {
            e[e.json = 0] = "json",
            e[e.string = 1] = "string"
        }(o.Proto || (o.Proto = {})),
        cc._RF.pop()
    }
    , {}],
    HallUI: [function(e, t, o) {
        "use strict";
        cc._RF.push(t, "17dab4dFUVC7IUN+hXrmtBY", "HallUI");
        var n, i = this && this.__extends || (n = function(e, t) {
            return (n = Object.setPrototypeOf || {
                __proto__: []
            }instanceof Array && function(e, t) {
                e.__proto__ = t
            }
            || function(e, t) {
                for (var o in t)
                    Object.prototype.hasOwnProperty.call(t, o) && (e[o] = t[o])
            }
            )(e, t)
        }
        ,
        function(e, t) {
            function o() {
                this.constructor = e
            }
            n(e, t),
            e.prototype = null === t ? Object.create(t) : (o.prototype = t.prototype,
            new o)
        }
        );
        Object.defineProperty(o, "__esModule", {
            value: !0
        });
        var r, a, s = e("../../base/common/Func"), c = e("../../base/common/MessageMgr"), l = e("../../base/common/SpecialFunc"), f = e("../../base/common/view/UIPicText"), h = e("../config/Config"), d = e("../../base/effect/EffectMgr"), u = e("../../base/net/EEvent"), p = e("../../base/net/NetMgr"), g = e("../../base/res/LanguageMgr"), _ = e("../../base/SoundMgr"), y = e("./CardUI"), m = e("../../base/common/view/PageView"), v = e("../../base/res/DyncLoadedBase"), b = e("../../base/res/DyncMgr"), C = e("../../base/LogicMgr"), M = e("../../base/LevelMgr");
        var P = function(e) {
            if ("undefined" != typeof window && window.parent) {
                var t = window.parent;
                void 0 !== e.Page && (t.Page = e.Page),
                void 0 !== e.Balance && (t.Balance = e.Balance),
                void 0 !== e.Grand && (t.Grand = e.Grand),
                void 0 !== e.Major && (t.Major = e.Major),
                void 0 !== e.Minor && (t.Minor = e.Minor),
                void 0 !== e.Mini && (t.Mini = e.Mini)
            }
        };
        (function(e) {
            e[e.grand = 0] = "grand",
            e[e.major = 1] = "major",
            e[e.minor = 2] = "minor",
            e[e.mini = 3] = "mini",
            e[e.num = 4] = "num"
        }
        )(r || (r = {})),
        function(e) {
            e[e.total = 0] = "total",
            e[e.all = 1] = "all",
            e[e.fav = 2] = "fav",
            e[e.fishing = 3] = "fishing",
            e[e.slot = 4] = "slot",
            e[e.other = 5] = "other",
            e[e.links = 6] = "links",
            e[e.num = 7] = "num"
        }(a || (a = {}));
        var S, w = cc.v3(0, 320), N = cc.v3(0, 258), B = function() {
            function e() {
                this._takeTime = 0,
                this._eff = null,
                this._msg = [],
                this._broadTextPos = cc.Vec3.ZERO
            }
            return e.prototype.init = function(e) {
                this._root = e;
                var t = e.getChildByName("mask");
                this._broadLength = t.getContentSize().width,
                this._textNode = t.getChildByName("text"),
                this._text = this._textNode.getComponent(cc.Label),
                this.clear()
            }
            ,
            e.prototype.clear = function() {
                this._takeTime = 0,
                this._msg.length = 0,
                this._text.string = "",
                this._root.setPosition(w),
                this._textNode.stopAllActions(),
                this._show && (this._show = !1,
                d.EffectMgr.Instance.removeEffect(this._eff))
            }
            ,
            e.prototype.addMsg = function(e) {
                this._msg.push(e),
                this._show || (this._show = !0,
                cc.tween(this._root).to(.35, {
                    position: N
                }).start(),
                this._eff = d.EffectMgr.Instance.trigger(d.EffectMgr.EffectType.EffectMeetCondition, 1, this.updateMsg.bind(this), this.end.bind(this)))
            }
            ,
            e.prototype.updateMsg = function() {
                if (this._takeTime < 0) {
                    this._text.string = this._msg.shift(),
                    this._text._forceUpdateRenderData();
                    var e = this._text.node.getContentSize().width + this._broadLength;
                    this._broadTextPos.x = this._broadLength / 2,
                    this._textNode.setPosition(this._broadTextPos),
                    this._takeTime = e / 50,
                    this._textNode.stopAllActions(),
                    this._broadTextPos.x -= e,
                    cc.tween(this._textNode).to(this._takeTime, {
                        position: this._broadTextPos
                    }).start()
                } else
                    this._takeTime -= 1;
                return 0 === this._msg.length
            }
            ,
            e.prototype.end = function() {
                var e = this;
                cc.tween(this._root).to(.35, {
                    position: w
                }).call(function() {
                    e._show = !1
                }).start()
            }
            ,
            e
        }();
        (function(e) {
            e[e.hour = 0] = "hour",
            e[e.minute = 1] = "minute",
            e[e.second = 2] = "second",
            e[e.num = 3] = "num"
        }
        )(S || (S = {}));
        var P = function(e) {
            function t(t, o) {
                var n = e.call(this, t, o) || this;
                return n._recTime = 0,
                n._recCnt = 0,
                n._movePos = cc.Vec3.ZERO,
                n._langNode = [],
                n._curPgIndex = 1,
                n._lastShowCategory = a.all,
                n._leftToggle = [],
                n._gid2CardUI = new Map,
                n._cardCfg = [],
                n._cards = [],
                n._animsReplay = [],
                n._bottomAnimsReplay = [],
                n._dayTimeArr = [0, 0, 0],
                n._browseNodes = [],
                n._loginNodes = [],
                n._curCredit = [],
                n._maxCredit = [],
                n._jpCredit = [],
                n._finishLoad = !1,
                n._broadcast = new B,
                c.MessageMgr.on(c.MessageName.InitBrosePage, n.loginSucceed, n),
                c.MessageMgr.on(c.MessageName.UserInfo, n.updateUserInfo, n),
                c.MessageMgr.on(c.MessageName.ChangeHeadIcon, n.changeHeadIcon, n),
                c.MessageMgr.on(c.MessageName.UpdateFavCards, n.updateFavCards, n),
                c.MessageMgr.on(c.MessageName.LoginSucceeded, function() {
                    C.default.browsePage = !1,
                    C.default.login.succeed = !0;
                    var e = localStorage.getItem("headIndex_" + C.default.login.userID);
                    if (e && (C.default.login.headIndex = Number(e)),
                    !s.default.getStorage("showNotice") && C.default.login.mainContent && (b.default.getResInfo("noticeTip"),
                    s.default.setStorage("showNotice", "0")),
                    n._finishLoad) {
                        for (var t = 0, o = n._animsReplay; t < o.length; t++)
                            o[t].play();
                        n.loginSucceed()
                    }
                }),
                n
            }
            return i(t, e),
            t.prototype.initParams = function() {
                var e = this;
                s.default.removeLoading();
                var t = []
                  , o = this.nodeInfo.root.getChildByName("glow");
                t.push(o);
                var n = this.nodeInfo.root.getChildByName("rocketRamp");
                if (h.Config.rocketRamp) {
                    this._loginNodes.push(n);
                    var i = document.getElementById("RocketRamp");
                    if (i) {
                        var r = document.createElement("script");
                        r.src = "https://app.myrocketramp.com/embed/button/",
                        r.async = !0,
                        r.defer = !0;
                        var l = this;
                        r.onload = function() {
                            l._rocketRampLabel = cc.find("Background/Label", n).getComponent(cc.Label),
                            i.getElementsByTagName("button"),
                            l._rocketRampDiv = document.querySelector("#RocketRamp .rr-btn"),
                            l.changRocketRampLang(),
                            n.on("click", function() {
                                l._rocketRampDiv.onclick()
                            })
                        }
                        ,
                        r.onerror = function() {
                            console.error("\u811a\u672c\u52a0\u8f7d\u5931\u8d25")
                        }
                        ,
                        i.appendChild(r)
                    }
                } else
                    n.active = !1;
                this._searchGidNode = this.nodeInfo.root.getChildByName("searchGid"),
                this._searchGidNode.active = !1,
                this._searchGidNode.on("text-changed", this.searchGidChanged, this);
                var g = this.nodeInfo.root.getChildByName("top");
                this._animsReplay.push(g.getComponent(cc.Animation)),
                t.push(g.getChildByName("shengdan"));
                var v = g.getChildByName("crashBack");
                this._loginNodes.push(v),
                h.Config.welfarePrize.cashBack_period ? (v.active = !0,
                1 == h.Config.welfarePrize.cashBack_period && (cc.find("anim/btn", v).on(C.ConstDefine.click, this.crashBackClick, this),
                v.getChildByName("label").destroy())) : v.active = !1,
                this._favSwitchNode = g.getChildByName("favSwitch"),
                this._loginNodes.push(this._favSwitchNode),
                this._favToggle = this._favSwitchNode.getComponent(cc.Toggle),
                this._favToggle.uncheck(),
                this._favSwitchNode.on("toggle", this.favToggle, this);
                var S = this.nodeInfo.root.getChildByName("broadcast");
                this._broadcast.init(S),
                this._loginNodes.push(S);
                var w = g.getChildByName("headIcon");
                w.on(C.ConstDefine.click, this.headIconClick, this),
                this._headIconSpt = w.getChildByName(C.ConstDefine.Background).getComponent(cc.Sprite);
                var N = g.getChildByName(C.ConstDefine.account);
                this._loginNodes.push(N),
                this._accountLable = N.getComponent(cc.Label),
                this._coinCountbarNode = g.getChildByName("coinCountbar"),
                M.default.Instance.setLevel(this._coinCountbarNode, h.AdaptLevel.creditUI),
                this._coinCountbarNode.setPosition(0, 360),
                this._coinCountbarNode.getChildByName("logo");
                for (var B = this._coinCountbarNode.getChildByName("jp"), P = 0, k = B.children; P < k.length; P++) {
                    var R = k[P];
                    this._langNode.push(R.getChildByName("bg")),
                    this._jpCredit.push(new f.default("jp",R.getChildByName(C.ConstDefine.credit)))
                }
                this.initRollJpCredit(),
                d.EffectMgr.Instance.trigger(d.EffectMgr.EffectType.EffectMeetCondition, .05, this.rollJpCredit.bind(this), C.ConstDefine.emptyFunc),
                this._browseNodes.push(B),
                this._coinCountbar = this._coinCountbarNode.children;
                var T = this._coinCountbar[0];
                this._singleCreditNode = T.getChildByName(C.ConstDefine.credit),
                this._singleCreditUIPic = new f.default(C.ConstDefine.credit,this._singleCreditNode);
                var I = this._coinCountbar[1];
                this._langNode.push(I.getChildByName("bg")),
                this._doubleCreditNode = I.getChildByName(C.ConstDefine.credit),
                this._doubleCreditUIPic = new f.default(C.ConstDefine.credit,this._doubleCreditNode),
                this._doubleScoreUIPic = new f.default(C.ConstDefine.credit,this._coinCountbar[1].getChildByName("score"));
                var D = this.nodeInfo.root.getChildByName("right");
                this._lastNode = D.getChildByName("last"),
                this._nextNode = D.getChildByName("next");
                var L = this.nodeInfo.root.getChildByName("bottom");
                t.push(L.getChildByName("shengdan"));
                var x = L.getComponent(cc.Animation);
                this._animsReplay.push(x);
                var E = L.getChildByName("quit");
                this._langNode.push(E.getChildByName("lang")),
                this._loginNodes.push(E),
                E.on(C.ConstDefine.click, this.quit, this),
                this._jackpotNode = L.getChildByName("jackpot"),
                this._langNode.push(this._jackpotNode.getChildByName("logo")),
                this._loginNodes.push(this._jackpotNode),
                this._jackpotNode.getChildByName(C.ConstDefine.click).on(C.ConstDefine.click, function() {
                    _.default.playEffect(C.ConstDefine.click),
                    b.default.getResInfo("jpUI")
                }),
                this._jackpotUIPic = new f.default(C.ConstDefine.credit,this._jackpotNode.getChildByName(C.ConstDefine.credit)),
                this._jackpotUIPic.setSepValue(C.default.jpTotalCredit);
                var O = L.getChildByName("login");
                this._langNode.push(O.getChildByName("loginText")),
                this._browseNodes.push(O),
                O.getChildByName("btn").on(C.ConstDefine.click, function() {
                    _.default.playEffect(C.ConstDefine.click),
                    b.default.getResInfo(C.ConstDefine.loginUI)
                });
                for (var F = L.getChildByName("floatCtrl"), A = 0, j = F.children; A < j.length; A++) {
                    var U = j[A];
                    this._langNode.push(U.getChildByName("text")),
                    cc.tween(U.getChildByName("frame")).to(2, {
                        y: 1
                    }, {
                        easing: "sineInOut"
                    }).to(2, {
                        y: -9
                    }, {
                        easing: "sineInOut"
                    }).union().repeatForever().start()
                }
                var G = F.getChildByName("noticeTip");
                this._bottomAnimsReplay.push(G.getComponent(cc.Animation)),
                G.on(C.ConstDefine.click, function() {
                    C.default.browsePage || (_.default.playEffect(C.ConstDefine.click),
                    b.default.getResInfo("noticeTip"))
                });
                var H = F.getChildByName(C.ConstDefine.password);
                this._bottomAnimsReplay.push(H.getComponent(cc.Animation)),
                H.on(C.ConstDefine.click, function() {
                    C.default.browsePage || (_.default.playEffect(C.ConstDefine.click),
                    b.default.getResInfo("modPwdBox"))
                });
                var z = F.getChildByName("setting");
                this._bottomAnimsReplay.push(z.getComponent(cc.Animation)),
                z.on(C.ConstDefine.click, function() {
                    _.default.playEffect(C.ConstDefine.click),
                    b.default.getResInfo("settingBox")
                });
                var V = F.getChildByName("share");
                this._bottomAnimsReplay.push(V.getComponent(cc.Animation)),
                V.on(C.ConstDefine.click, function() {
                    _.default.playEffect(C.ConstDefine.click),
                    b.default.getResInfo("shareUI")
                }),
                x.on("finished", function() {
                    for (var t = 0, o = e._bottomAnimsReplay; t < o.length; t++)
                        o[t].play()
                }),
                this._midNode = this.nodeInfo.root.getChildByName("mid"),
                this._noFavTip = this._midNode.getChildByName("noFavTip"),
                this._langNode.push(this._noFavTip),
                this._noFavTip.opacity = 0;
                var W = this._midNode.getChildByName("left");
                this._animsReplay.push(W.getComponent(cc.Animation));
                for (var J = function(t) {
                    var o = W.children[t];
                    q._langNode.push(o.getChildByName("Background")),
                    q._langNode.push(o.getChildByName("checkmark")),
                    q._leftToggle.push(o.getComponent(cc.Toggle)),
                    o.on(C.ConstDefine.click, function() {
                        C.default.browsePage || (_.default.playEffect(C.ConstDefine.click),
                        e.leftClick(t + 1, 0))
                    })
                }, q = this, K = 0; K < W.childrenCount; K++)
                    J(K);
                D = this._midNode.getChildByName("right");
                var X = cc.find("view/content", D);
                this._contentChildren = X.children;
                var Z = X.getChildByName("page1");
                Z.active = !0,
                this._page1CardRoot = Z.getChildByName("card");
                var Y = Z.getChildByName("ad");
                b.default.getResInfo("advert", Y);
                var Q = this.nodeInfo.root.getChildByName("dayPrize")
                  , $ = Q.getChildByName("btn");
                this._dayPrizeBtn = $.getComponent(cc.Button),
                $.on(C.ConstDefine.click, this.dayPrizeClick, this),
                this._dayPrizeAnim = $.getComponent(cc.Animation),
                this._dayPrizeTimeNode = Q.getChildByName("time"),
                this._dayPrizeTimeNode.active = !1,
                this._dayPrizeTimeLabel = this._dayPrizeTimeNode.getComponent(cc.Label),
                this._dayPrizeTimeLabel.string = "",
                this._loginNodes.push(Q),
                this._pagePrefab = X.getChildByName("page2"),
                b.default.getResInfo("card").then(function(t) {
                    for (var o = t.nodeInfo.root, n = a.all; n < a.num; n++)
                        e._cardCfg[n] = [];
                    for (var i in y.default.FavCards = e._cardCfg[a.fav],
                    C.default.kpKeyCfg) {
                        C.default.kpKeyCfg[i];
                        var r = cc.instantiate(o)
                          , s = new y.default(r);
                        e._cards.push(s)
                    }
                    e._searchCard = new y.default(cc.instantiate(o)),
                    e._searchCard.setActive(!1),
                    e._searchCard.setParent(e.nodeInfo.root);
                    var l = D.getComponent(cc.PageView)
                      , f = e._cards.length;
                    if (f <= 6)
                        for (l.removePage(e._pagePrefab),
                        n = 0; n < f; ++n)
                            e._cards[n].setParent(e._page1CardRoot);
                    else {
                        for (var h = 0; h < 6; ++h)
                            e._cards[h].setParent(e._page1CardRoot);
                        var d = f - 6
                          , g = Math.ceil(d / 8) - 1;
                        for (n = 0; n < g; n++)
                            l.addPage(cc.instantiate(e._pagePrefab));
                        for (; h < f; ++h) {
                            var _ = e.calcPgIndex(h + 1);
                            e._cards[h].setParent(e._contentChildren[_])
                        }
                    }
                    var v = {
                        root: D,
                        leftNode: e._lastNode,
                        rightNode: e._nextNode,
                        pgChangeCall: e.pgChange.bind(e),
                        btnType: m.BtnControlType.rightShow,
                        finishCall: function() {
                            e._finishLoad = !0,
                            C.default.login.succeed ? e.loginSucceed() : C.default.browsePage && (b.default.getResInfo(C.ConstDefine.loadingTip),
                            p.NetMgr.createWebSocket(),
                            c.MessageMgr.once(c.MessageName.NetOpen, function() {
                                p.NetMgr.send(u.Cmd.MDM_MB_LOGON, u.Cmd.SUB_MB_LOGON_GETGAMESERVER, {
                                    userid: 0
                                })
                            }))
                        },
                        toggleRoot: e.nodeInfo.root.getChildByName("toggleRoot"),
                        toggleName: "singleToggleA"
                    };
                    e._togglePgView = new m.TogglePageView(v)
                });
                for (var ee = 0, te = this._loginNodes; ee < te.length; ee++)
                    (U = te[ee]).active = !1;
                for (var oe = 0, ne = this._browseNodes; oe < ne.length; oe++)
                    (U = ne[oe]).active = !1;
                for (var ie = 0, re = t; ie < re.length; ie++) {
                    var ae = re[ie];
                    "shengdan" == h.Config.theme ? ae.active = !0 : ae.destroy()
                }
                this.nodeInfo.root.on(cc.Node.EventType.MOUSE_WHEEL, this.onMouseWheel, this, !0),
                c.MessageMgr.on(c.MessageName.NetMsg, this.onLogonNet, this),
                c.MessageMgr.on(c.MessageName.ChangeLang, this.changeLang, this),
                c.MessageMgr.on(c.MessageName.NetClose, this.netClose, this),
                c.MessageMgr.on(c.MessageName.UpdateCredit, this.updateCredit, this),
                c.MessageMgr.on(c.MessageName.ExitBrosePage, this.showLoginNode, this),
                c.MessageMgr.on(c.MessageName.ShowCreditBox, this.showCreditBox, this),
                this.changeLang()
            }
            ,
            t.prototype.onMouseWheel = function(e) {
                this._togglePgView.isScrolling() || (e.getScrollY() > 0 ? this._togglePgView.lastPg() : this._togglePgView.nextPg())
            }
            ,
            t.prototype.changeHeadIcon = function() {
                l.default.setDyncSpt(h.Config.dyncLoadDirIndex.headIcon, "headIcon/" + C.default.login.headIndex, this._headIconSpt)
            }
            ,
            t.prototype.updateUserInfo = function() {
                this._finishLoad && (C.default.login.openWinScore ? (this._doubleCreditUIPic.setSepValue(C.default.login.score),
                this._doubleScoreUIPic.setSepValue(C.default.login.winScore)) : this._singleCreditUIPic.setSepValue(C.default.login.score + C.default.login.winScore),
                P({
                    Balance: C.default.login.score + C.default.login.winScore
                }),
                this.dayPrizeResponse())
            }
            ,
            t.prototype.dayPrizeResponse = function() {
                if (1 === C.default.fuliData.blottery || 1 == C.default.fuliData.blotteryhappyweek)
                    this._dayPrizeAnim.enabled = !0,
                    this._dayPrizeBtn.interactable = !0,
                    this._dayPrizeTimeNode.active = !1;
                else {
                    this._dayPrizeAnim.enabled = !1,
                    this._dayPrizeBtn.interactable = !1,
                    this._dayPrizeTimeNode.active = !0;
                    for (var e = C.default.fuliData.refreshtime || "23:59:59", t = e.match(/\d+/g), o = 0; o < S.num; ++o)
                        this._dayTimeArr[o] = Number(t[o]);
                    this._dayLeftTime = 3600 * this._dayTimeArr[S.hour] + 60 * this._dayTimeArr[S.minute] + this._dayTimeArr[S.second],
                    this._dayPrizeTimeLabel.string = e,
                    clearInterval(this._dayPrizeInterval),
                    this._dayPrizeInterval = setInterval(this.updateDayPrizeTime.bind(this), 1e3)
                }
            }
            ,
            t.prototype.updateDayPrizeTime = function() {
                --this._dayLeftTime <= 0 ? (clearInterval(this._dayPrizeInterval),
                C.default.reqUserInfo()) : (--this._dayTimeArr[S.second] < 0 && (this._dayTimeArr[S.second] = 59,
                --this._dayTimeArr[S.minute] < 0 && (this._dayTimeArr[S.minute] = 59,
                --this._dayTimeArr[S.hour] < 0 && (this._dayTimeArr[S.hour] = 11))),
                this._dayPrizeTimeLabel.string = cc.js.formatStr("%s:%s:%s", s.default.fillZero(this._dayTimeArr[S.hour]), s.default.fillZero(this._dayTimeArr[S.minute]), s.default.fillZero(this._dayTimeArr[S.second])))
            }
            ,
            t.prototype.updateCredit = function() {
                C.default.login.openWinScore ? (this._doubleCreditUIPic.setSepValue(C.default.login.score),
                this._doubleScoreUIPic.setSepValue(C.default.login.winScore)) : this._singleCreditUIPic.setSepValue(C.default.login.score + C.default.login.winScore),
                P({
                    Balance: C.default.login.score + C.default.login.winScore
                })
            }
            ,
            t.prototype.initRollJpCredit = function() {
                for (var e = 0; e < h.Config.jpRollVal.length; ++e) {
                    var t = h.Config.jpRollVal[e];
                    this._curCredit[e] = s.default.randomInt(t[0], t[1]),
                    this._maxCredit[e] = s.default.randomInt(t[2], t[3]),
                    this._jpCredit[e].setStr(l.default.convertDecimalNum(this._curCredit[e]), "$")
                }
            }
            ,
            t.prototype.rollJpCredit = function() {
                if (C.default.browsePage)
                    for (var e = 0; e < this._jpCredit.length; ++e)
                        ++this._curCredit[e],
                        this._curCredit[e] > this._maxCredit[e] ? this.initRollJpCredit() : this._jpCredit[e].setStr(l.default.convertDecimalNum(this._curCredit[e]), "$")
            }
            ,
            t.prototype.dayPrizeClick = function() {
                _.default.playEffect("prize_2"),
                b.default.getResInfo(C.ConstDefine.rollPrize)
            }
            ,
            t.prototype.showCreditBox = function(e) {
                this._coinCountbarNode.active = e
            }
            ,
            t.prototype.showLoginNode = function() {
                var e = !C.default.browsePage;
                if (this._lastShowState != e) {
                    this._lastShowState = e;
                    for (var t = 0, o = this._loginNodes; t < o.length; t++)
                        o[t].active = e;
                    for (var n = 0, i = this._browseNodes; n < i.length; n++)
                        i[n].active = !e
                }
            }
            ,
            t.prototype.crashBackClick = function() {
                _.default.playEffect(C.ConstDefine.click),
                b.default.getResInfo("cashbackUI")
            }
            ,
            t.prototype.searchGidChanged = function(e) {
                var t = C.default.kpKeyCfg[Number(e.string)];
                t ? (this._searchCard.show(!0),
                this._searchCard.reset(t),
                this._searchCard.setActive(!0),
                this.loadCfgTex(t),
                this._midNode.active = !1) : (this._searchCard.show(!1),
                this._midNode.active = !0,
                this._searchCard.setActive(!1))
            }
            ,
            t.prototype.changRocketRampLang = function() {
                this._rocketRampDiv && (this._rocketRampDiv.textContent.indexOf("Get") >= 0 ? "en" == g.default.currLang ? this._rocketRampLabel.string = this._rocketRampDiv.textContent : this._rocketRampLabel.string = "obtener cr\xe9dito" : this._rocketRampLabel.string = this._rocketRampDiv.textContent)
            }
            ,
            t.prototype.changeLang = function() {
                this.changRocketRampLang(),
                g.default.procLangNodeArr(this._langNode)
            }
            ,
            t.prototype.netClose = function() {}
            ,
            t.prototype.loginSucceed = function() {
                this.showLoginNode(),
                this.dayPrizeResponse();
                for (var e = a.all; e < a.num; e++)
                    this._cardCfg[e].length = 0;
                for (var t = 0, o = C.default.kpSortGid; t < o.length; t++) {
                    var n = o[t];
                    (l = C.default.kpKeyCfg[n]).fav = !1,
                    C.default.cardShow(l) && (this._cardCfg[a.all].push(l),
                    this._cardCfg[a[l.fenlei]].push(l))
                }
                this._noFavTip.opacity = 0,
                y.default.FavCards.length = 0;
                var i = localStorage.getItem(C.default.login.userID + "_favArrStr");
                if (i) {
                    C.default.favArr = JSON.parse(i);
                    for (var r = 0, c = C.default.favArr; r < c.length; r++) {
                        n = c[r];
                        var l = C.default.kpKeyCfg[n];
                        C.default.cardShow(l) && (l.fav = !0,
                        y.default.FavCards.push(l))
                    }
                }
                var f = this._cardCfg[a.all];
                for (e = 0; e < f.length; ++e)
                    this._cards[e].init(f[e]);
                var d = 0
                  , u = a.all;
                if (this._searchGidNode.active = !1,
                C.default.login.succeed) {
                    C.default.login.testAcccount && (this._searchGidNode.active = !0),
                    C.default.needReset && b.default.getResInfo(C.ConstDefine.msgTip, g.default.procLangText("changePwdTip"), 5),
                    h.Config.VisitNotice && !s.default.getStorage(C.default.login.account) && (b.default.getResInfo("notice"),
                    s.default.setStorage(C.default.login.account, "1")),
                    C.default.login.openJp ? (this._jackpotNode.active = !0,
                    C.default.sendJpReq()) : this._jackpotNode.active = !1;
                    var p = s.default.getStorage("showCategory");
                    p && (u = parseInt(p));
                    var _ = s.default.getStorage("pgIndex");
                    if (_ && (d = parseInt(_)),
                    this._accountLable.string = C.default.login.gameID.toString(),
                    C.default.login.openWinScore ? (this._coinCountbar[0].active = !1,
                    this._coinCountbar[1].active = !0,
                    this._favSwitchNode.setPosition(-392, -42),
                    this._doubleCreditUIPic.setSepValue(C.default.login.score),
                    this._doubleScoreUIPic.setSepValue(C.default.login.winScore),
                    C.default.creditNode = this._doubleCreditNode) : (this._coinCountbar[0].active = !0,
                    this._coinCountbar[1].active = !1,
                    this._favSwitchNode.setPosition(260, -42),
                    this._singleCreditUIPic.setSepValue(C.default.login.score + C.default.login.winScore),
                    C.default.creditNode = this._singleCreditNode),
                    P({
                        Balance: C.default.login.score + C.default.login.winScore,
                        Page: this._curPgIndex
                    }),
                    this._broadcast.clear(),
                    C.default.login.noticMsg)
                        for (e = 0; e < 3; e++)
                            for (var m = 0, v = C.default.login.noticMsg; m < v.length; m++) {
                                var M = v[m];
                                this._broadcast.addMsg(M.msg)
                            }
                    this.changeHeadIcon()
                }
                this._leftToggle[u - 1].check(),
                this._lastShowCategory = void 0,
                this._togglePgView.clear();
                for (var S = 0, w = this._cards; S < w.length; S++)
                    w[S].show(!1);
                this.setCardActive(!0, this._cardCfg[u].length),
                this.leftClick(u, d)
            }
            ,
            t.prototype.favToggle = function() {
                _.default.playEffect(C.ConstDefine.click);
                for (var e = this._cardCfg[this._lastShowCategory], t = 0; t < e.length; ++t)
                    this._cards[t].setFavActive(this._favToggle.isChecked)
            }
            ,
            t.prototype.recClick = function() {
                _.default.playEffect(C.ConstDefine.click);
                var e = performance.now();
                e - this._recTime < 500 ? ++this._recCnt : this._recCnt = 0,
                this._recTime = e,
                this._recCnt > 0 && (this._recCnt = 0,
                b.default.getResInfo(C.ConstDefine.msgTip, g.default.procLangText("replayAvailable")))
            }
            ,
            t.prototype.moveMidNode = function() {
                cc.tween(this._midNode).to(.15, {
                    position: this._movePos
                }).start()
            }
            ,
            t.prototype.loadCfgTex = function(e) {
                e.loadLogo ? e.logoSpt && e.card.setLogoSpt() : l.default.loadRemoteSpt(h.Config.configPath + "kapai/", C.ConstDefine.kp, e.gid, function(t, o) {
                    e.loadLogo = !0,
                    t || (e.logoSpt = new cc.SpriteFrame(o),
                    e.card.setLogoSpt())
                }),
                e.loadIcon ? e.iconSpt && e.card.setIconSpt() : l.default.loadRemoteSpt(h.Config.configPath + "lang/" + g.default.currLang + "/kapai/", C.ConstDefine.kpl, e.gid, function(t, o) {
                    e.loadIcon = !0,
                    t || (e.iconSpt = new cc.SpriteFrame(o),
                    e.card.setIconSpt())
                })
            }
            ,
            t.prototype.setCardActive = function(e, t) {
                var o = 0
                  , n = 6;
                this._curPgIndex > 0 && (o = 6 + 8 * (this._curPgIndex - 1),
                n = 8),
                o + n > t && (n = t - o);
                for (var i = o + n; o < i; ++o)
                    this._cards[o].setActive(e)
            }
            ,
            t.prototype.pgChange = function(e, t, o) {
                if (void 0 === t && (t = !1),
                void 0 === o && (o = !1),
                null != this._lastShowCategory) {
                    var n = this._cardCfg[this._lastShowCategory].length;
                    if (0 !== n) {
                        var i = 0
                          , r = 14;
                        e > 0 && (i = 6 + 8 * (e - 1),
                        r = 16,
                        e > 1 ? (i -= 8,
                        r += 8) : (i -= 6,
                        r += 6)),
                        i + r > n && (r = n - i);
                        for (var a = i; a < i + r; a++)
                            this.loadCfgTex(this._cards[a].cfg);
                        this._curPgIndex !== e && (this.setCardActive(!1, n),
                        this._curPgIndex = e,
                        t && s.default.setStorage("pgIndex", this._curPgIndex.toString()),
                        P({
                            Page: this._curPgIndex
                        }),
                        this.setCardActive(!0, n))
                    }
                }
            }
            ,
            t.prototype.hideAllGame = function() {
                0 !== this._inNode.opacity && (this._inNode.opacity = 0,
                this._outNode.opacity = 255,
                this._movePos.x = -178,
                this.moveMidNode())
            }
            ,
            t.prototype.showCard = function(e, t) {
                var o = 0
                  , n = 0;
                void 0 !== this._lastShowCategory && (o = this._cardCfg[this._lastShowCategory].length,
                n = this.calcPgIndex(o) + 1);
                for (var i = this._cardCfg[e].length, r = this.calcPgIndex(i) + 1, c = n; c < r; c++)
                    this._togglePgView.setVisible(c, !0);
                for (c = r; c < n; c++)
                    this._togglePgView.setVisible(c, !1);
                for (this._togglePgView.resetPageCnt(r),
                this._nextNode.active = !1,
                this._lastNode.active = !1,
                c = i; c < o; c++)
                    this._cards[c].show(!1);
                for (c = o; c < i; ++c)
                    this._cards[c].show(!0);
                this._lastShowCategory = e,
                s.default.setStorage("showCategory", this._lastShowCategory.toString()),
                0 !== i || e != a.fav ? (this.resetCard(e),
                this._togglePgView.toggleRoll(t, !1)) : this._noFavTip.opacity = 255
            }
            ,
            t.prototype.leftClick = function(e, t) {
                this._togglePgView.pgView.stopAutoScroll(),
                this._lastShowCategory === e ? this._togglePgView.toggleRoll(t, !1) : (this._lastShowCategory == a.fav && (this._noFavTip.opacity = 0),
                this._favToggle.isChecked && (this._favToggle.uncheck(),
                this.favToggle()),
                this.showCard(e, t),
                this.pgChange(t, !0, !0))
            }
            ,
            t.prototype.updateFavCards = function() {
                if (this._lastShowCategory === a.fav) {
                    var e = this._cardCfg[a.fav].length;
                    this._cards[e].show(!1),
                    this.resetCard(a.fav);
                    var t = this.calcPgIndex(e) + 1
                      , o = this.calcPgIndex(e + 1) + 1;
                    t !== o && (this._togglePgView.setVisible(o - 1, !1),
                    this._togglePgView.resetPageCnt(t),
                    this._curPgIndex === o - 1 && this._curPgIndex >= 0 && (--this._curPgIndex,
                    s.default.setStorage("pgIndex", this._curPgIndex.toString())),
                    this._togglePgView.toggleRoll(this._curPgIndex, !1),
                    P({
                        Page: this._curPgIndex
                    }));
                    for (var n = 0, i = this._cardCfg[a.fav]; n < i.length; n++) {
                        var r = i[n];
                        this.loadCfgTex(r)
                    }
                }
            }
            ,
            t.prototype.calcPgIndex = function(e) {
                return e <= 6 ? 0 : Math.ceil((e - 6) / 8)
            }
            ,
            t.prototype.headIconClick = function() {
                C.default.browsePage || (_.default.playEffect(C.ConstDefine.click),
                b.default.getResInfo("headUI"))
            }
            ,
            t.prototype.resetCard = function(e) {
                for (var t = this._cardCfg[e], o = 0; o < t.length; ++o)
                    this._cards[o].reset(t[o])
            }
            ,
            t.prototype.quit = function() {
                _.default.playEffect(C.ConstDefine.click),
                b.default.getResInfo("exitPromptBox", g.default.procLangText("exitLogin"))
            }
            ,
            t.prototype.onLogonNet = function(e) {
                if (e.mainID === u.Cmd.MDM_MB_LOGON)
                    switch (e.subID) {
                    case u.Cmd.SUB_MB_GETJPSCORE_RESULT:
                        var t = e.data;
                        C.default.jp[0] = t.grand,
                        C.default.jp[1] = t.major,
                        C.default.jp[2] = t.minor,
                        C.default.jp[3] = t.mini,
                        C.default.jpTotalCredit = t.grand + t.major + t.minor + t.mini,
                        P({
                            Grand: t.grand,
                            Major: t.major,
                            Minor: t.minor,
                            Mini: t.mini
                        }),
                        this._jackpotUIPic.setSepValue(C.default.jpTotalCredit),
                        cc.js.array.fastRemove(C.default.netClose, u.Cmd.SUB_MB_LOGON_GETJPSCORE),
                        b.default.isLoad("jpUI") || 0 != C.default.netClose.length || p.NetMgr.close()
                    }
            }
            ,
            t
        }(v.default);
        o.default = P,
        cc._RF.pop()
    }
    , {
        "../../base/LevelMgr": "LevelMgr",
        "../../base/LogicMgr": "LogicMgr",
        "../../base/SoundMgr": "SoundMgr",
        "../../base/common/Func": "Func",
        "../../base/common/MessageMgr": "MessageMgr",
        "../../base/common/SpecialFunc": "SpecialFunc",
        "../../base/common/view/PageView": "PageView",
        "../../base/common/view/UIPicText": "UIPicText",
        "../../base/effect/EffectMgr": "EffectMgr",
        "../../base/net/EEvent": "EEvent",
        "../../base/net/NetMgr": "NetMgr",
        "../../base/res/DyncLoadedBase": "DyncLoadedBase",
        "../../base/res/DyncMgr": "DyncMgr",
        "../../base/res/LanguageMgr": "LanguageMgr",
        "../config/Config": "Config",
        "./CardUI": "CardUI"
    }],
    HeadUI: [function(e, t, o) {
        "use strict";
        cc._RF.push(t, "37fe5mjPmFNPoggQD6/V/70", "HeadUI");
        var n, i = this && this.__extends || (n = function(e, t) {
            return (n = Object.setPrototypeOf || {
                __proto__: []
            }instanceof Array && function(e, t) {
                e.__proto__ = t
            }
            || function(e, t) {
                for (var o in t)
                    Object.prototype.hasOwnProperty.call(t, o) && (e[o] = t[o])
            }
            )(e, t)
        }
        ,
        function(e, t) {
            function o() {
                this.constructor = e
            }
            n(e, t),
            e.prototype = null === t ? Object.create(t) : (o.prototype = t.prototype,
            new o)
        }
        );
        Object.defineProperty(o, "__esModule", {
            value: !0
        }),
        o.HeadUI = void 0;
        var r = e("../../base/common/MessageMgr")
          , a = e("../config/Config")
          , s = e("../../base/SoundMgr")
          , c = e("../../base/common/view/PageView")
          , l = e("../../base/common/view/Tip")
          , f = e("../../base/res/DyncMgr")
          , h = e("../../base/LogicMgr")
          , d = function(e) {
            function t(t, o) {
                return e.call(this, t, o) || this
            }
            return i(t, e),
            t.prototype.initParams = function() {
                var t = this;
                e.prototype.initParams.call(this),
                localStorage.getItem("head"),
                this._popupMethod.root.getChildByName(h.ConstDefine.close).on(h.ConstDefine.click, this.close, this);
                var o = this._popupMethod.root.getChildByName("offsetX");
                this._headSelectNode = o.getChildByName("headSelect"),
                this._headSelectNode.active = !1,
                cc.find("confirm", o).on(h.ConstDefine.click, this.confirmClick, this);
                var n = o.getChildByName("pgView");
                f.default.bundles[a.Config.dyncLoadDirIndex.headIcon].loadDir("headIcon", cc.SpriteFrame, function(e, o) {
                    if (e)
                        console.error("\u52a0\u8f7d\u5934\u50cf\u8d44\u6e90\u51fa\u9519", e);
                    else {
                        var i = o.length;
                        o.sort(function(e, t) {
                            return e.name.length !== t.name.length ? e.name.length - t.name.length : e.name.localeCompare(t.name)
                        });
                        var r = cc.find("view/content", n)
                          , a = n.getComponent(cc.PageView)
                          , l = r.getChildByName("page");
                        l.active = !0,
                        t._perPgNum = l.childrenCount;
                        for (var f = Math.ceil(i / t._perPgNum), d = 1; d < f; d++) {
                            var u = cc.instantiate(l);
                            a.addPage(u)
                        }
                        var p = f * t._perPgNum - i
                          , g = r.children[f - 1];
                        for (d = t._perPgNum - p; d < t._perPgNum; d++)
                            g.children[d].destroy();
                        var _ = function(e) {
                            for (var n = r.children[e].children, i = function(i) {
                                var r = n[i]
                                  , a = e * t._perPgNum + i;
                                r.getChildByName(h.ConstDefine.Background).getComponent(cc.Sprite).spriteFrame = o[a],
                                r.on(h.ConstDefine.click, function() {
                                    s.default.playEffect(h.ConstDefine.click),
                                    t.headClick(a, n[i])
                                })
                            }, a = 0; a < n.length; a++)
                                i(a)
                        };
                        for (d = 0; d < f; d++)
                            _(d);
                        t._headSelectNode.active = !0;
                        var y = {
                            root: n,
                            finishCall: t.resetHeadPage.bind(t),
                            toggleName: "singleToggleA",
                            btnType: c.BtnControlType.leftRightSeq
                        };
                        t._pgView = new c.TogglePageView(y)
                    }
                })
            }
            ,
            t.prototype.close = function() {
                e.prototype.close.call(this),
                this.resetHeadPage()
            }
            ,
            t.prototype.resetHeadPage = function() {
                var e = Math.floor(h.default.login.headIndex / this._perPgNum)
                  , t = h.default.login.headIndex % this._perPgNum;
                this._pgView.toggleOn(e, !1),
                this._pgView.pgScrollEnded(!1),
                this.headClick(h.default.login.headIndex, this._pgView.contents[e].children[t])
            }
            ,
            t.prototype.confirmClick = function() {
                s.default.playEffect(h.ConstDefine.click),
                h.default.login.headIndex = this._curHeadIndex,
                r.MessageMgr.emit(r.MessageName.ChangeHeadIcon),
                localStorage.setItem("headIndex_" + h.default.login.userID, this._curHeadIndex.toString()),
                e.prototype.hide.call(this)
            }
            ,
            t.prototype.headClick = function(e, t) {
                e !== this._curHeadIndex && (this._curHeadIndex = e,
                this._headSelectNode.setParent(t),
                this._headSelectNode.setPosition(h.ConstDefine.vec3ZERO))
            }
            ,
            t
        }(l.PopupBase);
        o.HeadUI = d,
        cc._RF.pop()
    }
    , {
        "../../base/LogicMgr": "LogicMgr",
        "../../base/SoundMgr": "SoundMgr",
        "../../base/common/MessageMgr": "MessageMgr",
        "../../base/common/view/PageView": "PageView",
        "../../base/common/view/Tip": "Tip",
        "../../base/res/DyncMgr": "DyncMgr",
        "../config/Config": "Config"
    }],
    Interface: [function(e, t, o) {
        "use strict";
        cc._RF.push(t, "298e4HVs/9B4LkMTltVFsjK", "Interface"),
        Object.defineProperty(o, "__esModule", {
            value: !0
        }),
        o.GameTag = void 0,
        function(e) {
            e[e.hot = 0] = "hot",
            e[e.new = 1] = "new",
            e[e.comingSoon = 2] = "comingSoon",
            e[e.newFeature = 3] = "newFeature",
            e[e.num = 4] = "num"
        }(o.GameTag || (o.GameTag = {})),
        cc._RF.pop()
    }
    , {}],
    JpRankUI: [function(e, t, o) {
        "use strict";
        cc._RF.push(t, "1c06c7E4MdGI6UJrrPN+o2w", "JpRankUI");
        var n, i = this && this.__extends || (n = function(e, t) {
            return (n = Object.setPrototypeOf || {
                __proto__: []
            }instanceof Array && function(e, t) {
                e.__proto__ = t
            }
            || function(e, t) {
                for (var o in t)
                    Object.prototype.hasOwnProperty.call(t, o) && (e[o] = t[o])
            }
            )(e, t)
        }
        ,
        function(e, t) {
            function o() {
                this.constructor = e
            }
            n(e, t),
            e.prototype = null === t ? Object.create(t) : (o.prototype = t.prototype,
            new o)
        }
        );
        Object.defineProperty(o, "__esModule", {
            value: !0
        });
        var r, a = e("../../base/SoundMgr"), s = e("./CustomScrollView"), c = e("../../base/LogicMgr"), l = e("../../base/common/view/UIPicText"), f = e("../../base/common/view/Tip"), h = e("../../base/common/MessageMgr"), d = e("../../base/net/NetMgr"), u = e("../../base/net/EEvent"), p = e("../../base/common/Func"), g = e("../../base/res/LanguageMgr"), _ = e("../../base/common/SpecialFunc");
        (function(e) {
            e[e.noData = 0] = "noData",
            e[e.noRecordLst = 1] = "noRecordLst",
            e[e.num = 2] = "num"
        }
        )(r || (r = {}));
        var y = ["grand", "major", "minor", "mini"]
          , m = function() {
            function e(e, t) {
                this._lastShowFrame = 0,
                this._root = e,
                this._frameChildren = e.getChildByName("frame").children;
                for (var o = 0, n = this._frameChildren; o < n.length; o++) {
                    var i = n[o];
                    i.opacity = 0,
                    i.active = !0
                }
                this._frameChildren[this._lastShowFrame].opacity = 255,
                this._orderUItext = new l.default("order",e.getChildByName("order")),
                this._orderUItext.setStr(t + 1),
                this._idLabel = cc.find("userID/id", e).getComponent(cc.Label),
                this._timeLabel = e.getChildByName("time").getComponent(cc.Label),
                this._creditUItext = new l.default(c.ConstDefine.credit,e.getChildByName(c.ConstDefine.credit))
            }
            return e.prototype.init = function(e) {
                this._idLabel.string = e.gameid.toString(),
                this._timeLabel.string = e.date,
                this._creditUItext.setValue(e.score, c.default.login.creditPrefix),
                this._lastShowFrame !== e.jptype && (this._frameChildren[this._lastShowFrame].opacity = 0,
                this._lastShowFrame = e.jptype,
                this._frameChildren[this._lastShowFrame].opacity = 255),
                this.setActive(!0)
            }
            ,
            e.prototype.setActive = function(e) {
                this._root.active = e
            }
            ,
            e
        }()
          , v = function(e) {
            function t() {
                var t = null !== e && e.apply(this, arguments) || this;
                return t._awardCredit = [],
                t._rankItems = [],
                t._langNode = [],
                t
            }
            return i(t, e),
            t.prototype.initParams = function() {
                var t = this;
                e.prototype.initParams.call(this),
                this._popupMethod.root.getChildByName(c.ConstDefine.close).on(c.ConstDefine.click, this.close, this);
                var o = this._popupMethod.root.getChildByName("offsetX")
                  , n = o.getChildByName("showInfoFrame");
                this._infoTip = n.getChildByName("info").getComponent(cc.Label),
                this._infoTip.string = "",
                this._noRecordNode = n.getChildByName("noRecordLst"),
                this._noRecordNode.opacity = 0,
                this._langNode.push(this._noRecordNode);
                var i = o.getChildByName("mid");
                this._awrdChildren = cc.find("left/award", i).children;
                for (var r = function(e) {
                    var o = l._awrdChildren[e];
                    l._langNode.push(o.getChildByName("Background")),
                    l._langNode.push(cc.find("checkmark/choosed", o)),
                    o.on("toggle", function() {
                        a.default.playEffect(c.ConstDefine.click),
                        t.toggleClick(e)
                    })
                }, l = this, f = 0; f < this._awrdChildren.length; f++)
                    r(f);
                var h = i.getChildByName("right");
                this._langNode.push(h.getChildByName("recorditemframe")),
                this._nodataNode = h.getChildByName("noData"),
                this._nodataNode.opacity = 0,
                this._langNode.push(this._nodataNode);
                var d = h.getChildByName("rank");
                s.CustomScrollView.addScrollBarExtra(d),
                this._contentNode = cc.find("view/content", d),
                this._itemPrefab = this._contentNode.getChildByName("prefab"),
                this._rankItems.length = 0,
                this._rankItems.push(new m(this._itemPrefab,this._rankItems.length)),
                this._rankItems[0].setActive(!1)
            }
            ,
            t.prototype.resetParams = function(t) {
                e.prototype.resetParams.call(this),
                this._laserIndexClick = -1,
                a.default.playEffect("jpEnter"),
                h.MessageMgr.on(h.MessageName.NetMsg, this.onLogonNet, this),
                this.nodeInfo.root.active = !0,
                this._awrdChildren[t].getComponent(cc.Toggle).check(),
                this.toggleClick(t),
                this.changeLang(),
                h.MessageMgr.on(h.MessageName.ChangeLang, this.changeLang, this)
            }
            ,
            t.prototype.close = function() {
                a.default.playEffect("jpClose"),
                this.hide(),
                d.NetMgr.close(),
                h.MessageMgr.off(h.MessageName.NetMsg, this.onLogonNet, this),
                h.MessageMgr.off(h.MessageName.ChangeLang, this.changeLang, this)
            }
            ,
            t.prototype.changeLang = function() {
                g.default.procLangNodeArr(this._langNode)
            }
            ,
            t.prototype.toggleClick = function(e) {
                this._laserIndexClick !== e && (this._laserIndexClick = e,
                c.default.login.succeed && (h.MessageMgr.once(h.MessageName.NetOpen, function() {
                    var t = {
                        type: e - 1,
                        bossid: c.default.login.bossID
                    };
                    d.NetMgr.send(u.Cmd.MDM_MB_LOGON, u.Cmd.SUB_MB_LOGON_GETJPRECORD, t)
                }),
                d.NetMgr.createWebSocket()))
            }
            ,
            t.prototype.onLogonNet = function(e) {
                if (e.mainID === u.Cmd.MDM_MB_LOGON && e.subID === u.Cmd.SUB_MB_GETJPRECORD_RESULT) {
                    var t = e.data;
                    if (this._infoTip.string = "",
                    0 === t.result)
                        if (null != t.item) {
                            for (var o = this._rankItems.length; o < t.item.length; o++) {
                                var n = cc.instantiate(this._itemPrefab);
                                n.setParent(this._contentNode),
                                this._rankItems.push(new m(n,o))
                            }
                            for (var i = t.item.length; i < this._rankItems.length; i++)
                                this._rankItems[i].setActive(!1);
                            this._nodataNode.opacity = 0,
                            this._noRecordNode.opacity = 255;
                            for (var r = 0; r < t.item.length; r++)
                                if ((h = t.item[r]).date = p.default.change2Time(h.date),
                                this._rankItems[r].init(h),
                                255 === this._noRecordNode.opacity && c.default.login.gameID === h.gameid) {
                                    this._noRecordNode.opacity = 0;
                                    var a = g.default.procLangText(y[h.jptype]);
                                    this._infoTip.string = cc.js.formatStr(g.default.procLangText("getPrize"), a, c.default.login.creditPrefix + _.default.convertDecimalNum(h.score), h.date)
                                }
                        } else {
                            this._nodataNode.opacity = 255,
                            this._noRecordNode.opacity = 255;
                            for (var s = 0; s < this._rankItems.length; s++)
                                this._rankItems[s].setActive(!1)
                        }
                    else {
                        cc.warn(t.msg),
                        this._nodataNode.opacity = 0;
                        for (var l = 0, f = this._rankItems; l < f.length; l++) {
                            var h;
                            (h = f[l]).setActive(!1)
                        }
                    }
                    d.NetMgr.close()
                }
            }
            ,
            t
        }(f.PopupBase);
        o.default = v,
        cc._RF.pop()
    }
    , {
        "../../base/LogicMgr": "LogicMgr",
        "../../base/SoundMgr": "SoundMgr",
        "../../base/common/Func": "Func",
        "../../base/common/MessageMgr": "MessageMgr",
        "../../base/common/SpecialFunc": "SpecialFunc",
        "../../base/common/view/Tip": "Tip",
        "../../base/common/view/UIPicText": "UIPicText",
        "../../base/net/EEvent": "EEvent",
        "../../base/net/NetMgr": "NetMgr",
        "../../base/res/LanguageMgr": "LanguageMgr",
        "./CustomScrollView": "CustomScrollView"
    }],
    JpUI: [function(e, t, o) {
        "use strict";
        cc._RF.push(t, "8ac3fWa2bdGsqd/HuJd5ISP", "JpUI");
        var n, i = this && this.__extends || (n = function(e, t) {
            return (n = Object.setPrototypeOf || {
                __proto__: []
            }instanceof Array && function(e, t) {
                e.__proto__ = t
            }
            || function(e, t) {
                for (var o in t)
                    Object.prototype.hasOwnProperty.call(t, o) && (e[o] = t[o])
            }
            )(e, t)
        }
        ,
        function(e, t) {
            function o() {
                this.constructor = e
            }
            n(e, t),
            e.prototype = null === t ? Object.create(t) : (o.prototype = t.prototype,
            new o)
        }
        );
        Object.defineProperty(o, "__esModule", {
            value: !0
        }),
        o.JpPrize = void 0;
        var r = e("../../base/SoundMgr")
          , a = e("../../base/LogicMgr")
          , s = e("../../base/common/view/UIPicText")
          , c = e("../../base/res/DyncLoadedBase")
          , l = e("../../base/common/MessageMgr")
          , f = e("../../base/net/NetMgr")
          , h = e("../../base/net/EEvent")
          , d = e("../../base/res/DyncMgr")
          , y = function(e) {
            if ("undefined" != typeof window && window.parent) {
                var t = window.parent;
                void 0 !== e.Grand && (t.Grand = e.Grand),
                void 0 !== e.Major && (t.Major = e.Major),
                void 0 !== e.Minor && (t.Minor = e.Minor),
                void 0 !== e.Mini && (t.Mini = e.Mini)
            }
        }
          , u = function() {
            function e(e, t) {
                this._credit = new s.default("jp",t.getChildByName(a.ConstDefine.credit)),
                this._titleSpt = t.getChildByName("1_2").children[0].getComponent(cc.Sprite),
                this.setCredit(a.default.jp[e])
            }
            return e.prototype.setCredit = function(e) {
                this._credit.setSepValue(e, a.default.login.creditPrefix)
            }
            ,
            e.prototype.setStr = function(e) {
                this._credit.setStr(e)
            }
            ,
            e.prototype.changeLang = function() {}
            ,
            e
        }()
          , p = function(e) {
            function t() {
                var t = null !== e && e.apply(this, arguments) || this;
                return t._awardBrand = [],
                t
            }
            return i(t, e),
            t.prototype.initParams = function() {
                var e = this
                  , t = this.nodeInfo.root.getChildByName("menubar");
                this._menubarAnim = t.getComponent(cc.Animation),
                t.getChildByName("back").on(a.ConstDefine.click, this.close, this),
                t.getChildByName("record").on(a.ConstDefine.click, function() {
                    e.recordClick(0)
                }, this);
                for (var o = this.nodeInfo.root.getChildByName("award").children, n = function(t) {
                    var n = o[t];
                    n.on(a.ConstDefine.click, function() {
                        e.recordClick(t + 1)
                    }, i),
                    i._awardBrand[t] = new u(t,n)
                }, i = this, r = 0; r < o.length; r++)
                    n(r);
                l.MessageMgr.on(l.MessageName.NetClose, this.netClose, this)
            }
            ,
            t.prototype.resetParams = function() {
                this._menubarAnim.play(),
                r.default.playEffect("jpEnter"),
                l.MessageMgr.once(l.MessageName.NetOpen, this.netOpen, this),
                f.NetMgr.createWebSocket(),
                l.MessageMgr.on(l.MessageName.NetMsg, this.onLogonNet, this)
            }
            ,
            t.prototype.netOpen = function() {
                var e = {
                    bossid: a.default.login.bossID,
                    dynamicpass: a.default.login.dynamicPass
                };
                f.NetMgr.send(h.Cmd.MDM_MB_LOGON, h.Cmd.SUB_MB_LOGON_GETJPSCORE, e)
            }
            ,
            t.prototype.close = function() {
                r.default.playEffect("jpClose"),
                this.hide(),
                f.NetMgr.close(),
                l.MessageMgr.off(l.MessageName.NetMsg, this.onLogonNet, this)
            }
            ,
            t.prototype.recordClick = function(e) {
                r.default.playEffect(a.ConstDefine.click),
                d.default.getResInfo("jpRankUI", e)
            }
            ,
            t.prototype.netClose = function() {}
            ,
            t.prototype.onLogonNet = function(e) {
                if (e.mainID === h.Cmd.MDM_MB_LOGON && e.subID === h.Cmd.SUB_MB_GETJPSCORE_RESULT) {
                    f.NetMgr.close();
                    var t = e.data;
                    this._awardBrand[0].setCredit(t.grand),
                    this._awardBrand[1].setCredit(t.major),
                    this._awardBrand[2].setCredit(t.minor),
                    this._awardBrand[3].setCredit(t.mini),
                    y({
                        Grand: t.grand,
                        Major: t.major,
                        Minor: t.minor,
                        Mini: t.mini
                    })
                }
            }
            ,
            t
        }(c.default);
        o.default = p;
        var g = function(e) {
            function t() {
                var t = null !== e && e.apply(this, arguments) || this;
                return t._awardBrand = [],
                t
            }
            return i(t, e),
            t.prototype.initParams = function() {
                this.nodeInfo.root.getChildByName("collect").on(a.ConstDefine.click, this.collectClick, this);
                for (var e = this.nodeInfo.root.getChildByName("award").children, t = 0; t < e.length; t++)
                    this._awardBrand[t] = new u(t,e[t])
            }
            ,
            t.prototype.hide = function() {}
            ,
            t.prototype.collectClick = function() {}
            ,
            t
        }(c.default);
        o.JpPrize = g,
        cc._RF.pop()
    }
    , {
        "../../base/LogicMgr": "LogicMgr",
        "../../base/SoundMgr": "SoundMgr",
        "../../base/common/MessageMgr": "MessageMgr",
        "../../base/common/view/UIPicText": "UIPicText",
        "../../base/net/EEvent": "EEvent",
        "../../base/net/NetMgr": "NetMgr",
        "../../base/res/DyncLoadedBase": "DyncLoadedBase",
        "../../base/res/DyncMgr": "DyncMgr"
    }],
    KeyboardUI: [function(e, t, o) {
        "use strict";
        cc._RF.push(t, "5142fkTfTNJg6Tb/M3XXUB/", "KeyboardUI");
        var n, i = this && this.__extends || (n = function(e, t) {
            return (n = Object.setPrototypeOf || {
                __proto__: []
            }instanceof Array && function(e, t) {
                e.__proto__ = t
            }
            || function(e, t) {
                for (var o in t)
                    Object.prototype.hasOwnProperty.call(t, o) && (e[o] = t[o])
            }
            )(e, t)
        }
        ,
        function(e, t) {
            function o() {
                this.constructor = e
            }
            n(e, t),
            e.prototype = null === t ? Object.create(t) : (o.prototype = t.prototype,
            new o)
        }
        );
        Object.defineProperty(o, "__esModule", {
            value: !0
        });
        var r = e("../../base/common/SpecialFunc")
          , a = e("../../base/LogicMgr")
          , s = e("../../base/res/DyncLoadedBase")
          , c = e("../../base/res/DyncMgr")
          , l = e("../../base/SoundMgr")
          , f = cc.Vec3.ZERO
          , h = function(e) {
            function t() {
                var t = null !== e && e.apply(this, arguments) || this;
                return t._patternMap = new Map,
                t._moveNodePos = cc.Vec3.ZERO,
                t
            }
            return i(t, e),
            t.prototype.initParams = function() {
                var e = this;
                this.nodeInfo.root.getChildByName("mask").on(a.ConstDefine.click, this.close, this),
                this._rootNode = this.nodeInfo.root.getChildByName("root"),
                this._patternNodes = this._rootNode.children,
                this._topmask = this.nodeInfo.root.getChildByName("topmask"),
                f.set(this._rootNode.position),
                f.y += this._patternNodes[0].height * this._patternNodes[0].anchorY * this._rootNode.scaleY,
                this._keyboardPos = this._rootNode.parent.convertToWorldSpaceAR(f);
                for (var t = 0; t < this._patternNodes.length; t++) {
                    var o = this._patternNodes[t];
                    o.active = !1;
                    for (var n = o.children, i = function(t) {
                        var o = n[t];
                        o.on(a.ConstDefine.click, function() {
                            e.keyClick(o.name)
                        })
                    }, s = 0; s < n.length; s++)
                        i(s);
                    this._patternMap.set(o.name, t)
                }
                this._pattern = this._patternMap.get("lower"),
                this._patternNodes[this._pattern].active = !0,
                this._btnCopy = this._rootNode.getChildByName("btnCopy"),
                this._btnPaste = this._rootNode.getChildByName("btnPaste"),
                this._btnCopy.on(a.ConstDefine.click, function() {
                    r.default.copyToClipboard(e._curEdit.string, function(e) {
                        c.default.getResInfo(a.ConstDefine.msgTip, e ? "copy successfully" : "copy fail", 3)
                    })
                }),
                this._btnPaste.on(a.ConstDefine.click, function() {
                    e._topmask.active || (e._topmask.active = !0,
                    setTimeout(function() {
                        r.default.pasteFormCliboard(e._curEdit, function() {
                            e._topmask.active = !1,
                            r.default.isRotateDev() && r.default.reqFullScreen(),
                            setTimeout(function() {
                                r.default.isRotateDev() && r.default.reqFullScreen()
                            }, 1e3)
                        })
                    }, 200))
                })
            }
            ,
            t.prototype.resetParams = function(e, t) {
                this._pattern !== this._patternMap.get("lower") && this.switchPattern(this._patternMap.get("lower")),
                this._curEdit = e.getComponent(cc.EditBox),
                this._moveNodePos.set(t.position),
                this._curMoveNode = t,
                f.set(e.position),
                f.y -= e.height * e.anchorY + 10;
                var o = e.parent.convertToWorldSpaceAR(f);
                if (o.y < this._keyboardPos.y) {
                    var n = this._keyboardPos.y - o.y
                      , i = n / 300;
                    i > .5 && (i = .5),
                    cc.tween(t).by(i, {
                        y: n
                    }).start()
                }
                var r = 0 == this._curEdit.inputFlag;
                this._btnCopy.active = !r,
                this._btnPaste.active = !0,
                this._topmask.active = !1
            }
            ,
            t.prototype.close = function() {
                l.default.playEffect("keyClick"),
                this._curMoveNode.setPosition(this._moveNodePos),
                this.hide(),
                r.default.isRotateDev() && r.default.reqFullScreen()
            }
            ,
            t.prototype.switchPattern = function(e) {
                this._patternNodes[this._pattern].active = !1,
                this._pattern = e,
                this._patternNodes[this._pattern].active = !0
            }
            ,
            t.prototype.keyClick = function(e) {
                switch (l.default.playEffect("keyClick"),
                e) {
                case "slash":
                    this._curEdit.string += "/";
                    break;
                case "space":
                    this._curEdit.string += " ";
                    break;
                case "del":
                    this._curEdit.string = this._curEdit.string.substring(0, this._curEdit.string.length - 1);
                    break;
                case "stowed":
                case "enter":
                    this.close();
                    break;
                case "upper":
                case "special":
                case "special2":
                case "lower":
                    this.switchPattern(this._patternMap.get(e));
                    break;
                default:
                    this._curEdit.string += e
                }
            }
            ,
            t
        }(s.default);
        o.default = h,
        cc._RF.pop()
    }
    , {
        "../../base/LogicMgr": "LogicMgr",
        "../../base/SoundMgr": "SoundMgr",
        "../../base/common/SpecialFunc": "SpecialFunc",
        "../../base/res/DyncLoadedBase": "DyncLoadedBase",
        "../../base/res/DyncMgr": "DyncMgr"
    }],
    LabelShader1: [function(e, t, o) {
        "use strict";
        cc._RF.push(t, "7bfabfniA1MQawb4i/9/pab", "LabelShader1");
        var n, i = this && this.__extends || (n = function(e, t) {
            return (n = Object.setPrototypeOf || {
                __proto__: []
            }instanceof Array && function(e, t) {
                e.__proto__ = t
            }
            || function(e, t) {
                for (var o in t)
                    Object.prototype.hasOwnProperty.call(t, o) && (e[o] = t[o])
            }
            )(e, t)
        }
        ,
        function(e, t) {
            function o() {
                this.constructor = e
            }
            n(e, t),
            e.prototype = null === t ? Object.create(t) : (o.prototype = t.prototype,
            new o)
        }
        ), r = this && this.__decorate || function(e, t, o, n) {
            var i, r = arguments.length, a = r < 3 ? t : null === n ? n = Object.getOwnPropertyDescriptor(t, o) : n;
            if ("object" == typeof Reflect && "function" == typeof Reflect.decorate)
                a = Reflect.decorate(e, t, o, n);
            else
                for (var s = e.length - 1; s >= 0; s--)
                    (i = e[s]) && (a = (r < 3 ? i(a) : r > 3 ? i(t, o, a) : i(t, o)) || a);
            return r > 3 && a && Object.defineProperty(t, o, a),
            a
        }
        ;
        Object.defineProperty(o, "__esModule", {
            value: !0
        });
        var a = cc._decorator
          , s = a.ccclass
          , c = a.property
          , l = a.menu
          , f = a.requireComponent
          , h = a.disallowMultiple
          , d = a.executeInEditMode
          , u = cc.Enum({
            None: 0,
            OneColor: 1,
            TwoColor: 2,
            TriColor: 3
        })
          , p = cc.Enum({
            None: 0,
            Lowp: 1,
            Mediump: 2,
            Highp: 3
        })
          , g = function(e) {
            function t() {
                var t = null !== e && e.apply(this, arguments) || this;
                return t.shadowUse = !1,
                t.shadowOffset = cc.v2(1, 1),
                t.shadowColor = cc.color(0, 0, 0, 150),
                t.outlineUse = !1,
                t.outlineWidth = 1,
                t.outlineColor = cc.color(0, 0, 0, 255),
                t.olShadowUse = !1,
                t.olShadowOffset = cc.v2(1, 1),
                t.olShadowColor = cc.color(0, 0, 0, 150),
                t.flowLightUse = !1,
                t.flSpeed = 1,
                t.flRot = 0,
                t.flWidth = 15,
                t.flColor = cc.color(255, 255, 255, 255),
                t.gradient = u.None,
                t.color1 = cc.color(255, 0, 0, 255),
                t.color2 = cc.color(0, 255, 0, 255),
                t.color3 = cc.color(0, 0, 255, 255),
                t.glow = p.None,
                t.glowWidth = 10,
                t.glowDepth = 2,
                t.glowColor = cc.color(255, 255, 255, 255),
                t._mtl = null,
                t._time = 0,
                t
            }
            return i(t, e),
            t.prototype.onLoad = function() {
                this.initMat()
            }
            ,
            t.prototype.initMat = function() {
                this._mtl = this.node.getComponent(cc.Label).getMaterial(0),
                this._mtl.define("USE_TEXTURE", !0, 0),
                this.node.getComponent(cc.Label).setMaterial(0, this._mtl),
                this.use()
            }
            ,
            t.prototype.use = function() {
                if (this._mtl) {
                    switch (this._mtl.setProperty("i_resolution", [this.node.width, this.node.height]),
                    this._mtl.setProperty("i_shadow", this.shadowUse ? 1 : 0),
                    this._mtl.setProperty("i_shadowOffset", [-this.shadowOffset.x / this.node.width, -this.shadowOffset.y / this.node.height]),
                    this._mtl.setProperty("i_shadowColor", [this.shadowColor.r / 255, this.shadowColor.g / 255, this.shadowColor.b / 255, this.shadowColor.a / 255]),
                    this._mtl.setProperty("i_outline", this.outlineUse ? 1 : 0),
                    this._mtl.setProperty("i_outlineWidth", [this.outlineWidth / this.node.width, this.outlineWidth / this.node.height]),
                    this._mtl.setProperty("i_outlineColor", [this.outlineColor.r / 255, this.outlineColor.g / 255, this.outlineColor.b / 255, this.outlineColor.a / 255]),
                    this._mtl.setProperty("i_olShadow", this.olShadowUse ? 1 : 0),
                    this._mtl.setProperty("i_olShadowOffset", [-this.olShadowOffset.x / this.node.width, -this.olShadowOffset.y / this.node.height]),
                    this._mtl.setProperty("i_olShadowColor", [this.olShadowColor.r / 255, this.olShadowColor.g / 255, this.olShadowColor.b / 255, this.olShadowColor.a / 255]),
                    this._mtl.setProperty("i_gradient", this.gradient - 1),
                    this.gradient) {
                    case u.None:
                        this._mtl.setProperty("i_color1", [this.node.color.r / 255, this.node.color.g / 255, this.node.color.b / 255, this.node.color.a / 255]);
                        break;
                    case u.OneColor:
                    case u.TwoColor:
                    case u.TriColor:
                        this._mtl.setProperty("i_color1", [this.node.color.r / 255, this.node.color.g / 255, this.node.color.b / 255, this.node.color.a / 255]),
                        this._mtl.setProperty("i_color1", [this.color1.r / 255, this.color1.g / 255, this.color1.b / 255, this.color1.a / 255]),
                        this._mtl.setProperty("i_color2", [this.color2.r / 255, this.color2.g / 255, this.color2.b / 255, this.color2.a / 255]),
                        this._mtl.setProperty("i_color3", [this.color3.r / 255, this.color3.g / 255, this.color3.b / 255, this.color3.a / 255])
                    }
                    this._mtl.setProperty("i_flowLight", this.flowLightUse ? 1 : 0),
                    this._mtl.setProperty("i_flTime", this.flSpeed * this._time * 60 / this.node.width),
                    this._mtl.setProperty("i_flRot", 180 * Math.atan(Math.tan(Math.PI * this.flRot / 180) * this.node.height / this.node.width) / Math.PI),
                    this._mtl.setProperty("i_flWidth", this.flWidth / this.node.width),
                    this._mtl.setProperty("i_flColor", [this.flColor.r / 255, this.flColor.g / 255, this.flColor.b / 255, this.flColor.a / 255]),
                    this._mtl.setProperty("i_glow", this.glow),
                    this._mtl.setProperty("i_glowWidth", [this.glowWidth / this.node.width, this.glowWidth / this.node.height]),
                    this._mtl.setProperty("i_glowDepth", this.glowDepth),
                    this._mtl.setProperty("i_glowColor", [this.glowColor.r / 255, this.glowColor.g / 255, this.glowColor.b / 255, this.glowColor.a / 255])
                }
            }
            ,
            t.prototype.update = function(e) {
                this._time += e,
                this.use()
            }
            ,
            r([c({
                tooltip: "\u662f\u5426\u4f7f\u7528\u9634\u5f71"
            })], t.prototype, "shadowUse", void 0),
            r([c({
                tooltip: "\u9634\u5f71\u504f\u79fb\uff08\u50cf\u7d20\uff09",
                visible: function() {
                    return this.shadowUse
                }
            })], t.prototype, "shadowOffset", void 0),
            r([c({
                tooltip: "\u9634\u5f71\u989c\u8272",
                visible: function() {
                    return this.shadowUse
                }
            })], t.prototype, "shadowColor", void 0),
            r([c({
                tooltip: "\u662f\u5426\u4f7f\u7528\u63cf\u8fb9"
            })], t.prototype, "outlineUse", void 0),
            r([c({
                tooltip: "\u63cf\u8fb9\u5bbd\u5ea6\uff08\u50cf\u7d20\uff09",
                min: 1,
                visible: function() {
                    return this.outlineUse
                }
            })], t.prototype, "outlineWidth", void 0),
            r([c({
                tooltip: "\u63cf\u8fb9\u989c\u8272",
                visible: function() {
                    return this.outlineUse
                }
            })], t.prototype, "outlineColor", void 0),
            r([c({
                tooltip: "\u662f\u5426\u4f7f\u7528\u63cf\u8fb9\u9634\u5f71",
                visible: function() {
                    return this.outlineUse
                }
            })], t.prototype, "olShadowUse", void 0),
            r([c({
                tooltip: "\u63cf\u8fb9\u9634\u5f71\u504f\u79fb\uff08\u50cf\u7d20\uff09",
                visible: function() {
                    return this.outlineUse && this.olShadowUse
                }
            })], t.prototype, "olShadowOffset", void 0),
            r([c({
                tooltip: "\u63cf\u8fb9\u9634\u5f71\u989c\u8272",
                visible: function() {
                    return this.outlineUse && this.olShadowUse
                }
            })], t.prototype, "olShadowColor", void 0),
            r([c({
                tooltip: "\u662f\u5426\u4f7f\u7528\u626b\u5149\u52a8\u6548"
            })], t.prototype, "flowLightUse", void 0),
            r([c({
                tooltip: "\u626b\u5149\u52a8\u6548\u901f\u5ea6\uff08\u50cf\u7d20\uff09",
                visible: function() {
                    return this.flowLightUse
                }
            })], t.prototype, "flSpeed", void 0),
            r([c({
                tooltip: "\u626b\u5149\u52a8\u6548\u65cb\u8f6c\u89d2\u5ea6",
                visible: function() {
                    return this.flowLightUse
                }
            })], t.prototype, "flRot", void 0),
            r([c({
                tooltip: "\u626b\u5149\u52a8\u6548\u5bbd\u5ea6\uff08\u50cf\u7d20\uff09",
                min: 1,
                visible: function() {
                    return this.flowLightUse
                }
            })], t.prototype, "flWidth", void 0),
            r([c({
                tooltip: "\u626b\u5149\u6548\u679c\u989c\u8272",
                visible: function() {
                    return this.flowLightUse
                }
            })], t.prototype, "flColor", void 0),
            r([c({
                tooltip: "\u6587\u5b57\u989c\u8272\nNone 0\uff1a\u5355\u8272\uff0c\u4f7f\u7528\u8282\u70b9color\nOneColor 1\uff1a\u5355\u8272\uff0c\u4f7f\u7528color1\nTwoColor 2\uff1a\u6e10\u53d8\u8272-\u53cc\u8272\nTriColor 3\uff1a\u6e10\u53d8\u8272-\u4e09\u8272",
                type: cc.Enum(u)
            })], t.prototype, "gradient", void 0),
            r([c({
                visible: function() {
                    return this.gradient > u.None
                }
            })], t.prototype, "color1", void 0),
            r([c({
                visible: function() {
                    return this.gradient > u.OneColor
                }
            })], t.prototype, "color2", void 0),
            r([c({
                visible: function() {
                    return this.gradient > u.TwoColor
                }
            })], t.prototype, "color3", void 0),
            r([c({
                tooltip: "\u5916\u53d1\u5149\uff0c\u5916\u53d1\u5149\u8f83\u8017\u6027\u80fd\nNone 0\uff1a\u4e0d\u4f7f\u7528\nLowp 1\uff1a\u4f4e\u7cbe\u5ea6\uff08\u5efa\u8bae\uff09\nMediump 2: \u4e2d\u7b49\u7cbe\u5ea6\nHighp 3\uff1a\u9ad8\u7cbe\u5ea6",
                type: cc.Enum(p)
            })], t.prototype, "glow", void 0),
            r([c({
                tooltip: "\u5916\u53d1\u5149\u5bbd\u5ea6\uff08\u50cf\u7d20\uff09",
                min: 1,
                visible: function() {
                    return this.glow > p.None
                }
            })], t.prototype, "glowWidth", void 0),
            r([c({
                tooltip: "\u5916\u53d1\u5149\u989c\u8272\u6df1\u5ea6",
                min: 1,
                max: 32,
                visible: function() {
                    return this.glow > p.None
                }
            })], t.prototype, "glowDepth", void 0),
            r([c({
                tooltip: "\u5916\u53d1\u5149\u989c\u8272",
                visible: function() {
                    return this.glow > p.None
                }
            })], t.prototype, "glowColor", void 0),
            r([s, l("UI/LabelShader1"), f(cc.Label), h(), d()], t)
        }(cc.Component);
        o.default = g,
        cc._RF.pop()
    }
    , {}],
    LangChange: [function(e, t, o) {
        "use strict";
        cc._RF.push(t, "a1d88DCPGdEiZMNbEVqQpy8", "LangChange");
        var n, i = this && this.__extends || (n = function(e, t) {
            return (n = Object.setPrototypeOf || {
                __proto__: []
            }instanceof Array && function(e, t) {
                e.__proto__ = t
            }
            || function(e, t) {
                for (var o in t)
                    Object.prototype.hasOwnProperty.call(t, o) && (e[o] = t[o])
            }
            )(e, t)
        }
        ,
        function(e, t) {
            function o() {
                this.constructor = e
            }
            n(e, t),
            e.prototype = null === t ? Object.create(t) : (o.prototype = t.prototype,
            new o)
        }
        ), r = this && this.__decorate || function(e, t, o, n) {
            var i, r = arguments.length, a = r < 3 ? t : null === n ? n = Object.getOwnPropertyDescriptor(t, o) : n;
            if ("object" == typeof Reflect && "function" == typeof Reflect.decorate)
                a = Reflect.decorate(e, t, o, n);
            else
                for (var s = e.length - 1; s >= 0; s--)
                    (i = e[s]) && (a = (r < 3 ? i(a) : r > 3 ? i(t, o, a) : i(t, o)) || a);
            return r > 3 && a && Object.defineProperty(t, o, a),
            a
        }
        ;
        Object.defineProperty(o, "__esModule", {
            value: !0
        });
        var a = e("../common/MessageMgr")
          , s = e("../common/view/NodeHandle")
          , c = e("../res/LanguageMgr")
          , l = cc._decorator
          , f = l.ccclass
          , h = l.property;
        (function(e) {
            function t() {
                var t = null !== e && e.apply(this, arguments) || this;
                return t.type = s.NodeHandleType.opacity,
                t
            }
            i(t, e),
            t.prototype.onLoad = function() {
                this._handleNode = s.createNodeHandle(this.type)
            }
            ,
            t.prototype.onEnable = function() {
                this.changeLang(),
                a.MessageMgr.on(a.MessageName.ChangeLang, this.changeLang, this)
            }
            ,
            t.prototype.onDisable = function() {
                a.MessageMgr.off(a.MessageName.ChangeLang, this.changeLang, this)
            }
            ,
            t.prototype.changeLang = function() {
                for (var e = 0, t = this.node.children; e < t.length; e++) {
                    var o = t[e];
                    o.name == c.default.currLang ? this._handleNode.reset(o) : this._handleNode.clear(o)
                }
            }
            ,
            r([h()], t.prototype, "type", void 0),
            t = r([f], t)
        }
        )(cc.Component),
        cc._RF.pop()
    }
    , {
        "../common/MessageMgr": "MessageMgr",
        "../common/view/NodeHandle": "NodeHandle",
        "../res/LanguageMgr": "LanguageMgr"
    }],
    LanguageMgr: [function(e, t, o) {
        "use strict";
        cc._RF.push(t, "54dd1hEGE1Bl7Ls3Nzlh/aI", "LanguageMgr");
        var n, i = this && this.__extends || (n = function(e, t) {
            return (n = Object.setPrototypeOf || {
                __proto__: []
            }instanceof Array && function(e, t) {
                e.__proto__ = t
            }
            || function(e, t) {
                for (var o in t)
                    Object.prototype.hasOwnProperty.call(t, o) && (e[o] = t[o])
            }
            )(e, t)
        }
        ,
        function(e, t) {
            function o() {
                this.constructor = e
            }
            n(e, t),
            e.prototype = null === t ? Object.create(t) : (o.prototype = t.prototype,
            new o)
        }
        );
        Object.defineProperty(o, "__esModule", {
            value: !0
        }),
        o.LabelReplace = o.ResReplace = void 0;
        var r = e("../common/Func")
          , a = e("../../my/config/Config")
          , s = e("../common/MessageMgr")
          , c = e("./TextDesc")
          , l = e("./BsLangText")
          , f = function() {
            function e(e, t) {
                this.type = e,
                this.name = t
            }
            return e.prototype.init = function() {}
            ,
            e
        }();
        o.ResReplace = f;
        var h = function(e) {
            function t(t, o, n) {
                var i = e.call(this, t, o) || this;
                return i.label = n.getComponent(cc.Label),
                i
            }
            return i(t, e),
            t.prototype.init = function() {
                this.label.string = d.procLangText(this.name)
            }
            ,
            t
        }(f);
        o.LabelReplace = h;
        var d = function() {
            function e() {}
            return e.confirmLang = function() {
                this.defaultLang = a.Config.defaultLang;
                var e = r.default.arrayStr2ObjectVal(a.Config.usingLang);
                this.currLang = this.lastLang = this.getLang(),
                this.curLangIndex = e[this.currLang]
            }
            ,
            e.getLang = function() {
                var e = localStorage.getItem("hLang");
                return null != e && a.Config.usingLang.find(function(t) {
                    return t == e
                }) || (e = this.defaultLang,
                localStorage.setItem("hLang", e)),
                e
            }
            ,
            e.showLang = function() {
                s.MessageMgr.emit(s.MessageName.ChangeLang)
            }
            ,
            e.setLang = function(e) {
                null != e && e !== this.curLangIndex && (this.curLangIndex = e,
                this.lastLang = this.currLang,
                this.currLang = a.Config.usingLang[e],
                localStorage.setItem("hLang", this.currLang),
                this.showLang())
            }
            ,
            e.getLangNode = function(e) {
                if (e) {
                    for (var t = 0; t < e.childrenCount; t++) {
                        if ((o = e.children[t]).name == this.currLang)
                            return o.active = !0,
                            o;
                        o.active = !1
                    }
                    for (t = 0; t < e.childrenCount; t++) {
                        var o;
                        if ((o = e.children[t]).name == this.defaultLang)
                            return o.active = !0,
                            o;
                        o.active = !1
                    }
                    return console.assert(!1, "\u672a\u627e\u5230\u8bed\u8a00\u7684\u76f8\u5173\u8282\u70b9"),
                    null
                }
            }
            ,
            e.procPrizeText = function(e, t) {
                return cc.js.formatStr(c.LangText[this.currLang].awardsTip, e, c.LangText[this.currLang][t])
            }
            ,
            e.procLangText = function(e) {
                return c.LangText[this.currLang][e] || c.LangText[this.defaultLang][e]
            }
            ,
            e.procLangLabel = function(t) {
                t.getComponent(cc.Label).string = e.procLangText(t.name)
            }
            ,
            e.procLangLabelArr = function(e) {
                for (var t = 0, o = e; t < o.length; t++) {
                    var n = o[t];
                    this.procLangLabel(n)
                }
            }
            ,
            e.procLangNode = function(t) {
                for (var o = 0, n = t.children; o < n.length; o++) {
                    var i = n[o];
                    i.name == e.currLang ? i.opacity = 255 : i.opacity = 0
                }
            }
            ,
            e.procLangNodeArr = function(e) {
                for (var t = 0, o = e; t < o.length; t++) {
                    var n = o[t];
                    this.procLangNode(n)
                }
            }
            ,
            e.procBsText = function(e) {
                return l.default[this.currLang][e] || e
            }
            ,
            e
        }();
        o.default = d,
        cc._RF.pop()
    }
    , {
        "../../my/config/Config": "Config",
        "../common/Func": "Func",
        "../common/MessageMgr": "MessageMgr",
        "./BsLangText": "BsLangText",
        "./TextDesc": "TextDesc"
    }],
    LayeredBatchingAssembler: [function(e, t, o) {
        "use strict";
        cc._RF.push(t, "23a71M/HjhBfrH55L2AFQv9", "LayeredBatchingAssembler");
        var n, i = this && this.__extends || (n = function(e, t) {
            return (n = Object.setPrototypeOf || {
                __proto__: []
            }instanceof Array && function(e, t) {
                e.__proto__ = t
            }
            || function(e, t) {
                for (var o in t)
                    Object.prototype.hasOwnProperty.call(t, o) && (e[o] = t[o])
            }
            )(e, t)
        }
        ,
        function(e, t) {
            function o() {
                this.constructor = e
            }
            n(e, t),
            e.prototype = null === t ? Object.create(t) : (o.prototype = t.prototype,
            new o)
        }
        );
        Object.defineProperty(o, "__esModule", {
            value: !0
        });
        var r = e("./GTSimpleSpriteAssembler2D")
          , a = cc.RenderFlow.FLAG_RENDER | cc.RenderFlow.FLAG_POST_RENDER
          , s = cc.RenderFlow.FLAG_OPACITY | cc.RenderFlow.FLAG_WORLD_TRANSFORM
          , c = !0
          , l = function(e) {
            function t() {
                return null !== e && e.apply(this, arguments) || this
            }
            return i(t, e),
            t.prototype.fillBuffers = function(t, o) {
                if (e.prototype.fillBuffers.call(this, t, o),
                c) {
                    var n = [];
                    this._layers = [n];
                    var i = (o.worldMatDirty ? cc.RenderFlow.FLAG_WORLD_TRANSFORM : 0) | (o.parentOpacityDirty ? cc.RenderFlow.FLAG_OPACITY_COLOR : 0);
                    t.node.__gtDirtyFlag = i;
                    var r = [];
                    r.push(t.node);
                    for (var l, f = 1, h = 0; h < r.length; ) {
                        var d = r[h++];
                        i = d.__gtDirtyFlag;
                        for (var u = 0, p = d.children; u < p.length; u++) {
                            var g = p[u];
                            g._activeInHierarchy && 0 !== g._opacity && ((l = g._renderFlag & a) > 0 && (g.__gtRenderFlag = l,
                            g._renderFlag &= ~l,
                            n.push(g)),
                            g.__gtDirtyFlag = i | g._renderFlag & s,
                            r.push(g))
                        }
                        h == f && (f = r.length,
                        n = [],
                        this._layers.push(n))
                    }
                }
            }
            ,
            t.prototype.postFillBuffers = function(e, t) {
                var o = t.worldMatDirty;
                if (c && this._layers) {
                    var n, i;
                    c = !1;
                    for (var r = 0, a = this._layers; r < a.length; r++) {
                        var s = a[r];
                        if (0 != s.length)
                            for (var l = 0, f = s; l < f.length; l++) {
                                var h = f[l];
                                n = h.__gtRenderFlag,
                                i = h.__gtDirtyFlag,
                                t.worldMatDirty = i > 0 ? 1 : 0,
                                h._renderFlag |= n,
                                cc.RenderFlow.flows[n]._func(h)
                            }
                    }
                    this._layers = null,
                    c = !0,
                    t.worldMatDirty = o
                }
            }
            ,
            t
        }(r.default);
        o.default = l,
        cc._RF.pop()
    }
    , {
        "./GTSimpleSpriteAssembler2D": "GTSimpleSpriteAssembler2D"
    }],
    LayeredBatchingRootRenderer: [function(e, t, o) {
        "use strict";
        cc._RF.push(t, "46eac+6VhpKm7WzZ9hgKJzc", "LayeredBatchingRootRenderer");
        var n, i = this && this.__extends || (n = function(e, t) {
            return (n = Object.setPrototypeOf || {
                __proto__: []
            }instanceof Array && function(e, t) {
                e.__proto__ = t
            }
            || function(e, t) {
                for (var o in t)
                    Object.prototype.hasOwnProperty.call(t, o) && (e[o] = t[o])
            }
            )(e, t)
        }
        ,
        function(e, t) {
            function o() {
                this.constructor = e
            }
            n(e, t),
            e.prototype = null === t ? Object.create(t) : (o.prototype = t.prototype,
            new o)
        }
        ), r = this && this.__decorate || function(e, t, o, n) {
            var i, r = arguments.length, a = r < 3 ? t : null === n ? n = Object.getOwnPropertyDescriptor(t, o) : n;
            if ("object" == typeof Reflect && "function" == typeof Reflect.decorate)
                a = Reflect.decorate(e, t, o, n);
            else
                for (var s = e.length - 1; s >= 0; s--)
                    (i = e[s]) && (a = (r < 3 ? i(a) : r > 3 ? i(t, o, a) : i(t, o)) || a);
            return r > 3 && a && Object.defineProperty(t, o, a),
            a
        }
        ;
        Object.defineProperty(o, "__esModule", {
            value: !0
        });
        var a = e("./LayeredBatchingAssembler")
          , s = cc._decorator
          , c = s.ccclass
          , l = (s.property,
        function(e) {
            function t() {
                return null !== e && e.apply(this, arguments) || this
            }
            return i(t, e),
            t.prototype.onEnable = function() {
                e.prototype.onEnable.call(this),
                this.node._renderFlag |= cc.RenderFlow.FLAG_POST_RENDER
            }
            ,
            t.prototype._resetAssembler = function() {
                this.setVertsDirty(),
                (this._assembler = new a.default).init(this)
            }
            ,
            r([c], t)
        }(cc.Sprite));
        o.default = l,
        cc._RF.pop()
    }
    , {
        "./LayeredBatchingAssembler": "LayeredBatchingAssembler"
    }],
    LevelMgr: [function(e, t, o) {
        "use strict";
        cc._RF.push(t, "c079euVqZJOIoZSvuFBFIJd", "LevelMgr");
        var n, i = this && this.__extends || (n = function(e, t) {
            return (n = Object.setPrototypeOf || {
                __proto__: []
            }instanceof Array && function(e, t) {
                e.__proto__ = t
            }
            || function(e, t) {
                for (var o in t)
                    Object.prototype.hasOwnProperty.call(t, o) && (e[o] = t[o])
            }
            )(e, t)
        }
        ,
        function(e, t) {
            function o() {
                this.constructor = e
            }
            n(e, t),
            e.prototype = null === t ? Object.create(t) : (o.prototype = t.prototype,
            new o)
        }
        ), r = this && this.__decorate || function(e, t, o, n) {
            var i, r = arguments.length, a = r < 3 ? t : null === n ? n = Object.getOwnPropertyDescriptor(t, o) : n;
            if ("object" == typeof Reflect && "function" == typeof Reflect.decorate)
                a = Reflect.decorate(e, t, o, n);
            else
                for (var s = e.length - 1; s >= 0; s--)
                    (i = e[s]) && (a = (r < 3 ? i(a) : r > 3 ? i(t, o, a) : i(t, o)) || a);
            return r > 3 && a && Object.defineProperty(t, o, a),
            a
        }
        ;
        Object.defineProperty(o, "__esModule", {
            value: !0
        });
        var a = e("../my/config/Config")
          , s = e("./LogicMgr")
          , c = cc._decorator
          , l = c.ccclass
          , f = (c.property,
        function(e) {
            function t() {
                return null !== e && e.apply(this, arguments) || this
            }
            var o;
            return i(t, e),
            o = t,
            t.prototype.onLoad = function() {
                o.Instance = this;
                for (var e = 0; e < a.AdaptLevel.num; e++)
                    this.addNode(e, a.AdaptLevel[e], this.node)
            }
            ,
            t.prototype.setLevel = function(e, t) {
                e.setParent(this.node.children[t])
            }
            ,
            t.prototype.addNode = function(e, t, o) {
                var n = new cc.Node(t);
                o.addChild(n),
                n.setSiblingIndex(e),
                n.setPosition(s.ConstDefine.vec3ZERO)
            }
            ,
            t.Instance = new o,
            o = r([l], t)
        }(cc.Component));
        o.default = f,
        cc._RF.pop()
    }
    , {
        "../my/config/Config": "Config",
        "./LogicMgr": "LogicMgr"
    }],
    LogicMgr: [function(e, t, o) {
        "use strict";
        cc._RF.push(t, "6d9d7SGokVJKofeuF8/zlOP", "LogicMgr"),
        Object.defineProperty(o, "__esModule", {
            value: !0
        }),
        o.ActualName = o.ConstDefine = void 0,
        o.ConstDefine = {
            vec2ZERO: cc.Vec2.ZERO,
            vec3ZERO: cc.Vec3.ZERO,
            emptyFunc: function() {},
            trueFunc: function() {
                return !0
            },
            wsPrefix: "ws://",
            loadingTip: "loadingTip",
            click: "click",
            close: "close",
            id: "id",
            rollPrize: "rollPrize",
            msgTip: "msgTip",
            credit: "credit",
            hallUI: "hallUI",
            loginUI: "loginUI",
            msgPromptBox: "msgPromptBox",
            textMgr: "textMgr",
            Background: "Background",
            account: "account",
            password: "password",
            savePwd: "pwd",
            musicName: "hMN",
            toggle: "toggle",
            text: "text",
            remember: "remember",
            singleToggle: "singleToggle",
            none: "none",
            logonData: "logonData",
            tag: "tag",
            ad: "ad",
            bad: "bad",
            kp: "kp",
            kpl: "kpl",
            fuli: "fuli",
            jpReq: "jpReq"
        },
        o.ActualName = {
            hallUI: "hallUI",
            demoTip: "demoTip"
        };
        var n = function() {
            function e() {}
            return e.relogin = function() {
                e.login.succeed = !1,
                s.NetMgr.createWebSocket()
            }
            ,
            e.reqUserInfo = function() {
                e.netClose.push(h.Cmd.SUB_MB_LOGON_USERINFO2);
                var t = {
                    userid: this.login.userID,
                    password: this.login.pwd
                };
                s.NetMgr.isOpen() ? s.NetMgr.send(h.Cmd.MDM_MB_LOGON, h.Cmd.SUB_MB_LOGON_USERINFO2, t) : (s.NetMgr.createWebSocket(),
                a.MessageMgr.once(a.MessageName.NetOpen, function() {
                    s.NetMgr.send(h.Cmd.MDM_MB_LOGON, h.Cmd.SUB_MB_LOGON_USERINFO2, t)
                }))
            }
            ,
            e.exitLogin = function() {
                r.default.removeStorage(o.ConstDefine.logonData),
                this.login.succeed = !1,
                e.login.account = "",
                a.MessageMgr.emit(a.MessageName.LoginFail),
                s.NetMgr.close(),
                this.autoLogining = !1,
                l.default.hide(o.ConstDefine.loadingTip),
                l.default.getResInfo(o.ConstDefine.loginUI)
            }
            ,
            e.loginFailTip = function(e, t, n) {
                this.exitLogin(),
                l.default.getResInfo(o.ConstDefine.msgTip, c.default.procBsText(e), t, n)
            }
            ,
            e.updateUserInfo = function(t) {
                e.login.dynamicPass = t.dynamicpass,
                e.login.score = t.score,
                e.login.winScore = t.winscore,
                "undefined" != typeof window && window.parent && (window.parent.Balance = e.login.score + e.login.winScore)
            }
            ,
            e.saveLoginData = function() {
                i.Config.autoLogin && r.default.setStorage(o.ConstDefine.logonData, r.default.customEncry(JSON.stringify(this.login)))
            }
            ,
            e.assignLoginData = function(t) {
                e.login = t,
                e.login.testAcccount && e.loadDebugPanel(),
                e.procCardItem()
            }
            ,
            e.procCardItem = function() {
                var t, o, n = [], r = [];
                if (r.push.apply(r, e.allGid),
                e.kpSortGid.length = 0,
                i.Config.kpSortGid)
                    for (var a = 0, s = i.Config.kpSortGid; a < s.length; a++) {
                        var c = s[a];
                        cc.js.array.remove(r, c) && e.kpSortGid.push(c)
                    }
                for (var l = 0; l < e.login.cardsItem.length; l++) {
                    var f = e.login.cardsItem[l]
                      , h = e.kpKeyCfg[f.gid];
                    h && (h.bsPort = f.port,
                    h.tablecount = f.tablecount,
                    h.address = f.address,
                    h.mixed = !0,
                    cc.js.array.remove(r, f.gid) && (h.testGame ? n.push(f.gid) : e.kpSortGid.push(f.gid)))
                }
                (t = e.kpSortGid).push.apply(t, n),
                (o = e.kpSortGid).push.apply(o, r)
            }
            ,
            e.onLogonNet = function(t) {
                var n = t.data;
                if (t.mainID === h.Cmd.MDM_MB_LOGON)
                    switch (t.subID) {
                    case h.Cmd.SUB_MB_LOGON_RESULT:
                        if (clearTimeout(e.loginTimeOut),
                        0 == n.result) {
                            e.login.userID = n.userid,
                            e.login.gameID = n.gameid,
                            e.login.bossID = n.bossid,
                            e.login.noticMsg = n.noticmsg,
                            e.login.openWinScore = n.openwinscore,
                            e.login.openJp = n.openjp,
                            e.login.mainContent = n.maincontent,
                            e.updateUserInfo(n);
                            var r = {
                                userid: n.userid
                            };
                            s.NetMgr.send(h.Cmd.MDM_MB_LOGON, h.Cmd.SUB_MB_LOGON_GETGAMESERVER, r),
                            !e.login.testAcccount && n.needreset ? e.needReset = !0 : e.needReset = !1,
                            n.opendollar && (e.login.creditPrefix = "$")
                        } else
                            e.loginFailTip(n.msg, 3, !0);
                        break;
                    case h.Cmd.SUB_MB_LOGON_USERINFO_REP2:
                        if (cc.js.array.fastRemove(e.netClose, h.Cmd.SUB_MB_LOGON_USERINFO2),
                        console.log("\u8fd4\u56de\u7528\u6237\u6d88\u606f", n),
                        0 == n.result) {
                            for (var c in e.updateUserInfo(n),
                            e.fuliData)
                                e.fuliData[c] = n[c];
                            e.login.succeed ? a.MessageMgr.emit(a.MessageName.UserInfo) : a.MessageMgr.emit(a.MessageName.LoginSucceeded),
                            0 == e.netClose.length && s.NetMgr.close()
                        }
                        break;
                    case h.Cmd.SUB_MB_GETGAMESERVER_RESULT:
                        if ("" === e.login.account && s.NetMgr.close(),
                        0 == n.result) {
                            if (clearTimeout(e.loginTimeOut),
                            null === n.item && (n.item = {}),
                            e.login.cardsItem = n.item,
                            e.procCardItem(),
                            l.default.hide(o.ConstDefine.loadingTip),
                            e.login.guangGao = i.Config.guangGao,
                            "" === e.login.account)
                                return void a.MessageMgr.emit(a.MessageName.InitBrosePage);
                            e.reqUserInfo(),
                            a.MessageMgr.emit(a.MessageName.LoginSucceeded),
                            i.Config.autoEnterGame && f.default.startGame(e.kpKeyCfg[i.Config.autoEnterGame]),
                            e.saveLoginData()
                        } else
                            e.loginFailTip(n.msg, 3, !0)
                    }
            }
            ,
            e.loadDebugPanel = function() {
                e.login.testAcccount = !0,
                l.default.isLoad("debugPanel") || l.default.getResInfo("debugPanel"),
                "undefined" == typeof VConsole || window.vConsole || (window.vConsole = new VConsole)
            }
            ,
            e.connect = function(t, n) {
                e.login.testAcccount = !1,
                i.Config.debug && i.Config.testAcFormat && t.match(i.Config.testAcFormat) && e.loadDebugPanel(),
                e.login.account = t,
                e.login.pwd = n,
                l.default.getResInfo(o.ConstDefine.loadingTip),
                s.NetMgr.createWebSocket(),
                a.MessageMgr.once(a.MessageName.NetOpen, function() {
                    if (!e.login.succeed && "" !== e.login.account) {
                        var t = {
                            account: e.login.account,
                            password: e.login.pwd,
                            version: i.Config.version
                        };
                        s.NetMgr.send(h.Cmd.MDM_MB_LOGON, h.Cmd.SUB_MB_LOGON_WEBSOCKET, t)
                    }
                }),
                e.autoLogining || (clearTimeout(e.loginTimeOut),
                e.loginTimeOut = setTimeout(function() {
                    e.loginFailTip(c.default.procLangText("badNetStatus"), 5, !0)
                }, 15e3))
            }
            ,
            e.procLoginData = function(e, t) {
                l.default.getResInfo(o.ConstDefine.hallUI),
                this.autoLogining = !0,
                this.browsePage = !1,
                this.login.succeed = !1,
                this.connect(e, t)
            }
            ,
            e.onTextLoad = function() {
                a.MessageMgr.on(a.MessageName.NetMsg, this.onLogonNet, this),
                "loginUI" == i.Config.beginPage && (this.browsePage = !1);
                var e, t = null;
                if (i.Config.autoLogin) {
                    var n = r.default.getStorage(o.ConstDefine.logonData);
                    if (n) {
                        var s = r.default.customDecrypt(n);
                        return t = JSON.parse(s),
                        this.assignLoginData(t),
                        l.default.getResInfo(o.ConstDefine.hallUI),
                        this.login.succeed = !1,
                        this.browsePage = !1,
                        void this.reqUserInfo()
                    }
                }
                if ("" !== i.Config.urlParam) {
                    var c = i.Config.urlParam;
                    if ((e = r.default.decryptAES(c).split("|")) && e[0] && "" != e[0] && e[1] && "" != e[1])
                        return void this.procLoginData(e[0], e[1])
                }
                l.default.getResInfo(i.Config.beginPage)
            }
            ,
            e.sendJpReq = function() {
                e.netClose.push(h.Cmd.SUB_MB_LOGON_GETJPSCORE);
                var t = {
                    bossid: this.login.bossID
                };
                s.NetMgr.isOpen() ? s.NetMgr.send(h.Cmd.MDM_MB_LOGON, h.Cmd.SUB_MB_LOGON_GETJPSCORE, t) : (s.NetMgr.createWebSocket(),
                a.MessageMgr.once(a.MessageName.NetOpen, function() {
                    s.NetMgr.send(h.Cmd.MDM_MB_LOGON, h.Cmd.SUB_MB_LOGON_GETJPSCORE, t)
                }))
            }
            ,
            e.cardShow = function(e) {
                return !!e && (this.login.testAcccount || e.t === d.GameTag.comingSoon || !e.testGame && e.mixed || this.browsePage)
            }
            ,
            e.v2Tmp = cc.Vec3.ZERO,
            e.v3Tmp = cc.Vec3.ZERO,
            e.browsePage = !0,
            e.autoLogining = !1,
            e.needReset = !1,
            e.bigGG = {},
            e.kpKeyCfg = {},
            e.kpSortGid = [],
            e.favArr = [],
            e.useSoftKeyboard = !0,
            e.allGid = [],
            e.msgNotify = {
                maintenance: []
            },
            e.jp = [0, 0, 0, 0],
            e.jpTotalCredit = 0,
            e.fuliData = {
                blottery: 0,
                refreshtime: "23:59:59",
                blotterycashback: 1,
                blotteryfudai: 1,
                blotteryhappyweek: 0,
                bstarttiming: 1,
                cashbackscore: 1,
                msg: "",
                refreshtimecashback: "23:59:59",
                refreshtimefudai: "",
                refreshtimehappyweek: "23:59:59"
            },
            e.netClose = [],
            e.login = {
                testAcccount: !1,
                creditPrefix: "",
                guangGao: [],
                cardsItem: [],
                succeed: !1,
                account: "",
                userID: 0,
                gameID: 0,
                score: 0,
                bossID: 0,
                dynamicPass: "",
                openJp: 0,
                winScore: 0,
                openWinScore: !1,
                noticMsg: void 0,
                mainContent: void 0,
                headIndex: 0,
                pwd: ""
            },
            e
        }();
        o.default = n;
        var i = e("../my/config/Config")
          , r = e("./common/Func")
          , a = e("./common/MessageMgr")
          , s = e("./net/NetMgr")
          , c = e("./res/LanguageMgr")
          , l = e("./res/DyncMgr")
          , f = e("./net/GameNet")
          , h = e("./net/EEvent")
          , d = e("./common/Interface");
        cc._RF.pop()
    }
    , {
        "../my/config/Config": "Config",
        "./common/Func": "Func",
        "./common/Interface": "Interface",
        "./common/MessageMgr": "MessageMgr",
        "./net/EEvent": "EEvent",
        "./net/GameNet": "GameNet",
        "./net/NetMgr": "NetMgr",
        "./res/DyncMgr": "DyncMgr",
        "./res/LanguageMgr": "LanguageMgr"
    }],
    LoginUI: [function(e, t, o) {
        "use strict";
        cc._RF.push(t, "40ea4Tr+EZP34t8n7ZEeWF4", "LoginUI");
        var n, i = this && this.__extends || (n = function(e, t) {
            return (n = Object.setPrototypeOf || {
                __proto__: []
            }instanceof Array && function(e, t) {
                e.__proto__ = t
            }
            || function(e, t) {
                for (var o in t)
                    Object.prototype.hasOwnProperty.call(t, o) && (e[o] = t[o])
            }
            )(e, t)
        }
        ,
        function(e, t) {
            function o() {
                this.constructor = e
            }
            n(e, t),
            e.prototype = null === t ? Object.create(t) : (o.prototype = t.prototype,
            new o)
        }
        );
        Object.defineProperty(o, "__esModule", {
            value: !0
        }),
        o.LoginUI = void 0;
        var r, a = e("../../base/common/Func"), s = e("../config/Config"), c = e("../../base/res/LanguageMgr"), l = e("../../base/common/MessageMgr"), f = e("../../base/common/SpecialFunc"), h = e("../../base/SoundMgr"), d = e("../../base/res/DyncLoadedBase"), u = e("../../base/res/DyncMgr"), p = e("../../base/LogicMgr");
        (function(e) {
            e[e.account = 0] = "account",
            e[e.password = 1] = "password",
            e[e.forget = 2] = "forget",
            e[e.loginBtn = 3] = "loginBtn",
            e[e.num = 4] = "num"
        }
        )(r || (r = {}));
        var g = function(e) {
            function t(t, o) {
                var n = e.call(this, t, o) || this;
                return n._accountEdit = null,
                n._pwdEdit = null,
                n
            }
            return i(t, e),
            t.prototype.initParams = function() {
                a.default.removeLoading(),
                u.default.isLoad(p.ConstDefine.hallUI) || u.default.getResInfo(p.ConstDefine.hallUI);
                var e = this.nodeInfo.root.getChildByName("root")
                  , t = e.getChildByName("login");
                this._loginBtn = t.getComponent(cc.Button),
                t.on(p.ConstDefine.click, this.loginClick, this);
                var o = e.getChildByName(p.ConstDefine.account);
                this._accountEdit = o.getComponent(cc.EditBox),
                f.default.editInput(o, e);
                var n = e.getChildByName(p.ConstDefine.password);
                this._pwdEdit = n.getComponent(cc.EditBox),
                f.default.editInput(n, e);
                var i = e.getChildByName("version").getComponent(cc.Label);
                i.string = s.Config.version,
                i.node.active = !1;
                var r = e.getChildByName("assist");
                r.getChildByName("forget").on(p.ConstDefine.click, this.forget, this);
                var l = r.getChildByName("rememberMe");
                l.on(p.ConstDefine.toggle, this.rememberToggle, this),
                this._rememberToggle = l.getComponent(cc.Toggle);
                var d = e.getChildByName("close");
                "loginUI" == s.Config.beginPage ? d.active = !1 : d.on(p.ConstDefine.click, this.close, this);
                var g = e.getChildByName("langSelect")
                  , _ = c.default.getLang();
                g.getChildByName(_).getComponent(cc.Toggle).check();
                for (var y = function(e) {
                    g.children[e].on(p.ConstDefine.click, function() {
                        c.default.setLang(e)
                    })
                }, m = 0; m < g.childrenCount; ++m)
                    y(m);
                p.default.useSoftKeyboard || (this._accountEdit._impl._elem.autocomplete = "off",
                f.default.setSecEdit(this._pwdEdit),
                n.on("editing-return", this.returnKeyOn, this),
                o.on("editing-return", this.returnKeyOn, this),
                n.on("text-changed", function() {
                    h.default.playEffect("keyClick")
                }),
                o.on("text-changed", function() {
                    h.default.playEffect("keyClick")
                }))
            }
            ,
            t.prototype.resetParams = function() {
                if (p.default.useSoftKeyboard || (this._accountEdit._impl._elem.style.visibility = "visible",
                this._pwdEdit._impl._elem.style.visibility = "visible"),
                this._accountEdit.string = "",
                this._pwdEdit.string = "",
                this._loginBtn.interactable = !0,
                l.MessageMgr.on(l.MessageName.TouchStart, this.touchStart, this),
                l.MessageMgr.on(l.MessageName.LoginSucceeded, this.loginSucceed, this),
                l.MessageMgr.on(l.MessageName.LoginFail, this.loginFail, this),
                Number(localStorage.getItem(p.ConstDefine.remember))) {
                    this._rememberToggle.check();
                    var e = localStorage.getItem(p.ConstDefine.account);
                    e && (this._accountEdit.string = e);
                    var t = localStorage.getItem(p.ConstDefine.savePwd);
                    t && (this._pwdEdit.string = window.atob(t))
                } else
                    this._rememberToggle.uncheck();
                l.MessageMgr.emit(l.MessageName.ShowCreditBox, !1)
            }
            ,
            t.prototype.loginSucceed = function() {
                this._rememberToggle.isChecked ? (localStorage.setItem(p.ConstDefine.account, this._accountEdit.string),
                localStorage.setItem(p.ConstDefine.savePwd, window.btoa(this._pwdEdit.string))) : (localStorage.removeItem(p.ConstDefine.account),
                localStorage.removeItem(p.ConstDefine.savePwd),
                this._accountEdit.string = "",
                this._pwdEdit.string = ""),
                this.hide()
            }
            ,
            t.prototype.loginFail = function() {
                var e = this;
                u.default.getResInfo(p.ConstDefine.loadingTip),
                setTimeout(function() {
                    u.default.hide(p.ConstDefine.loadingTip),
                    e._loginBtn.interactable = !0
                }, 3e4)
            }
            ,
            t.prototype.close = function() {
                p.default.browsePage = !0,
                l.MessageMgr.emit(l.MessageName.ExitBrosePage),
                u.default.getResInfo(p.ConstDefine.hallUI),
                e.prototype.close.call(this)
            }
            ,
            t.prototype.hide = function() {
                p.default.useSoftKeyboard || (this._accountEdit._impl._elem.style.visibility = "hidden",
                this._pwdEdit._impl._elem.style.visibility = "hidden"),
                a.default.setStorage("id", this._accountEdit.string),
                l.MessageMgr.off(l.MessageName.TouchStart, this.touchStart, this),
                l.MessageMgr.off(l.MessageName.LoginSucceeded, this.loginSucceed, this),
                l.MessageMgr.off(l.MessageName.LoginFail, this.loginFail, this),
                e.prototype.hide.call(this),
                l.MessageMgr.emit(l.MessageName.ShowCreditBox, !0)
            }
            ,
            t.prototype.touchStart = function() {
                u.default.isLoad("keyboardUI") || h.default.playEffect(p.ConstDefine.click)
            }
            ,
            t.prototype.returnKeyOn = function() {
                this._loginBtn.interactable && this.login()
            }
            ,
            t.prototype.rememberToggle = function() {
                var e = "1";
                this._rememberToggle.isChecked || (this._accountEdit.string = "",
                this._pwdEdit.string = "",
                e = "0",
                localStorage.removeItem(p.ConstDefine.account),
                localStorage.removeItem(p.ConstDefine.savePwd)),
                localStorage.setItem(p.ConstDefine.remember, e)
            }
            ,
            t.prototype.forget = function() {
                h.default.playEffect(p.ConstDefine.click),
                u.default.getResInfo(p.ConstDefine.msgPromptBox, c.default.procLangText("forgetTip"))
            }
            ,
            t.prototype.loginClick = function() {
                h.default.playEffect(p.ConstDefine.click),
                this.login()
            }
            ,
            t.prototype.login = function() {
                var e = this._accountEdit.string
                  , t = this._pwdEdit.string;
                switch (!0) {
                case 0 === e.length:
                    u.default.getResInfo(p.ConstDefine.msgTip, c.default.procLangText("accountEmptyTip"), 2, !0);
                    break;
                case 0 === t.length:
                    u.default.getResInfo(p.ConstDefine.msgTip, c.default.procLangText("pwdEmptyTip"), 2, !0);
                    break;
                default:
                    this._loginBtn.interactable = !1,
                    p.default.connect(e, a.default.encryMd5(t))
                }
            }
            ,
            t
        }(d.default);
        o.LoginUI = g,
        cc._RF.pop()
    }
    , {
        "../../base/LogicMgr": "LogicMgr",
        "../../base/SoundMgr": "SoundMgr",
        "../../base/common/Func": "Func",
        "../../base/common/MessageMgr": "MessageMgr",
        "../../base/common/SpecialFunc": "SpecialFunc",
        "../../base/res/DyncLoadedBase": "DyncLoadedBase",
        "../../base/res/DyncMgr": "DyncMgr",
        "../../base/res/LanguageMgr": "LanguageMgr",
        "../config/Config": "Config"
    }],
    Main: [function(e, t, o) {
        "use strict";
        cc._RF.push(t, "3df069O4aRLa7UVXVrKUwvj", "Main");
        var n, i = this && this.__extends || (n = function(e, t) {
            return (n = Object.setPrototypeOf || {
                __proto__: []
            }instanceof Array && function(e, t) {
                e.__proto__ = t
            }
            || function(e, t) {
                for (var o in t)
                    Object.prototype.hasOwnProperty.call(t, o) && (e[o] = t[o])
            }
            )(e, t)
        }
        ,
        function(e, t) {
            function o() {
                this.constructor = e
            }
            n(e, t),
            e.prototype = null === t ? Object.create(t) : (o.prototype = t.prototype,
            new o)
        }
        ), r = this && this.__decorate || function(e, t, o, n) {
            var i, r = arguments.length, a = r < 3 ? t : null === n ? n = Object.getOwnPropertyDescriptor(t, o) : n;
            if ("object" == typeof Reflect && "function" == typeof Reflect.decorate)
                a = Reflect.decorate(e, t, o, n);
            else
                for (var s = e.length - 1; s >= 0; s--)
                    (i = e[s]) && (a = (r < 3 ? i(a) : r > 3 ? i(t, o, a) : i(t, o)) || a);
            return r > 3 && a && Object.defineProperty(t, o, a),
            a
        }
        ;
        Object.defineProperty(o, "__esModule", {
            value: !0
        });
        var a = e("./common/Func")
          , s = e("./common/MessageMgr")
          , c = e("../my/config/Config")
          , l = e("./effect/EffectMgr")
          , f = e("./net/NetMgr")
          , h = e("./res/DyncMgr")
          , d = e("./res/LanguageMgr")
          , u = e("./common/SpecialFunc")
          , p = e("./LogicMgr")
          , g = e("./common/Interface")
          , _ = cc._decorator
          , y = _.ccclass
          , m = (_.property,
        function(e) {
            function t() {
                return null !== e && e.apply(this, arguments) || this
            }
            var o;
            return i(t, e),
            o = t,
            t.prototype.onLoad = function() {}
            ,
            t.prototype.start = function() {
                var e = this;
                cc.debug.setDisplayStats(!1),
                cc.game.setFrameRate(30),
                o.frameSize = cc.view.getFrameSize();
                var t = window.top.location.href
                  , n = t.lastIndexOf("?");
                if (n >= 0 ? (c.Config.urlParam = t.substring(n + 1, t.length),
                c.Config.basePath = t.substring(0, n)) : c.Config.basePath = t,
                (n = (t = window.document.location.href).indexOf("/hall")) >= 0 && (c.Config.basePath = t.substring(0, n + 1)),
                cc.sys.isBrowser) {
                    var i = new Date
                      , r = "";
                    if (window.parent) {
                        var a = window.parent.document.getElementById("configSuffix");
                        a && (r = a.textContent)
                    }
                    c.Config.configPath = c.Config.basePath + "plat/config/hall/" + c.Config.platName + r + "/",
                    cc.game.canvas.style.cursor = "url('" + c.Config.configPath + "cursor.png'), pointer";
                    var h = c.Config.configPath + "config.json?=" + i.getTime();
                    f.NetMgr.sendHttpGet(h, this.quaryLoginConfigCB.bind(this)),
                    this.quaryMsg()
                } else
                    this.quaryLoginConfigCB(void 0);
                s.MessageMgr.once(s.MessageName.LoadDyncResFinish, function() {
                    l.EffectMgr.Instance.trigger(l.EffectMgr.EffectType.EffectMeetCondition, 20, e.quaryMsg.bind(e), p.ConstDefine.emptyFunc)
                })
            }
            ,
            t.prototype.quaryMsg = function() {
                var e = new Date
                  , t = c.Config.configPath + "msg.json?=" + e.getTime();
                f.NetMgr.sendHttpGet(t, function(e) {
                    p.default.msgNotify = e
                })
            }
            ,
            t.prototype.quaryLoginConfigCB = function(e) {
                a.default.mergeJSON(e, c.Config),
                u.default.isRotateDev() ? p.default.useSoftKeyboard = !0 : p.default.useSoftKeyboard = c.Config.pcUseSoftKey;
                for (var t = 0, o = c.Config.bigGG; t < o.length; t++)
                    --(i = o[t]).t,
                    p.default.bigGG[i.gid] = i;
                for (var n in c.Config.bigGG = null,
                this.convertCardArrCfg(c.Config.kapian),
                c.Config.kapian = null,
                this.convertCardArrCfg(c.Config.testGames, !0),
                c.Config.testGames = null,
                c.Config.wsUrl = c.Config.gameProtocol + c.Config.bsIp + ":" + c.Config.wsPort,
                c.Config.debug || (console.log = p.ConstDefine.emptyFunc),
                p.default.kpKeyCfg) {
                    var i;
                    -1 === (i = p.default.kpKeyCfg[n]).url.indexOf("http://") && (i.url = c.Config.basePath + i.url)
                }
                s.MessageMgr.emit(s.MessageName.LoadCfgFinish),
                d.default.confirmLang(),
                h.default.init()
            }
            ,
            t.prototype.convertCardArrCfg = function(e, t) {
                void 0 === t && (t = !1);
                for (var o = 0, n = e; o < n.length; o++) {
                    var i = n[o];
                    -1 !== p.default.allGid.indexOf(i.gid) ? console.error("\u6ce8\u610f\u5361\u7247\u914d\u7f6e\u4e2d\u6709\u91cd\u590d\u7684gid,\u7a0b\u5e8f\u9ed8\u8ba4\u9009\u53d6\u5148\u914d\u7f6e\u7684", i.gid) : (p.default.allGid.push(i.gid),
                    p.default.kpKeyCfg[i.gid] = i,
                    i.testGame = t,
                    void 0 !== i.t && ((i.t > g.GameTag.num || i.t <= 0) && console.error("\u914d\u7f6e\u91cct\u8d4b\u503c\u8fc7\u5927\u8fc7\u5c0f", i),
                    i.t -= 1))
                }
            }
            ,
            t.prototype.registerEvent = function() {
                u.default.isRotateDev() && (cc.game.canvas.addEventListener("blur", function() {
                    cc.game.isPaused() || cc.game.pause()
                }),
                cc.game.canvas.addEventListener("focus", function() {
                    cc.game.isPaused() && cc.game.resume()
                }))
            }
            ,
            t.reSetScreenSize = !0,
            o = r([y], t)
        }(cc.Component));
        o.default = m,
        cc._RF.pop()
    }
    , {
        "../my/config/Config": "Config",
        "./LogicMgr": "LogicMgr",
        "./common/Func": "Func",
        "./common/Interface": "Interface",
        "./common/MessageMgr": "MessageMgr",
        "./common/SpecialFunc": "SpecialFunc",
        "./effect/EffectMgr": "EffectMgr",
        "./net/NetMgr": "NetMgr",
        "./res/DyncMgr": "DyncMgr",
        "./res/LanguageMgr": "LanguageMgr"
    }],
    MessageMgr: [function(e, t, o) {
        "use strict";
        cc._RF.push(t, "1bec6YFPxJItrDUe1BlFzER", "MessageMgr");
        var n, i = this && this.__spreadArrays || function() {
            for (var e = 0, t = 0, o = arguments.length; t < o; t++)
                e += arguments[t].length;
            var n = Array(e)
              , i = 0;
            for (t = 0; t < o; t++)
                for (var r = arguments[t], a = 0, s = r.length; a < s; a++,
                i++)
                    n[i] = r[a];
            return n
        }
        ;
        Object.defineProperty(o, "__esModule", {
            value: !0
        }),
        o.MessageMgr = o.MessageName = void 0,
        function(e) {
            e.LoginSucceeded = "LoginSucceeded",
            e.LoginFail = "LoginFail",
            e.LoadCfgFinish = "LoadCfgFinish",
            e.LoadDyncResFinish = "LoadDyncResFinish",
            e.TouchStart = "TouchStart",
            e.TouchMove = "TouchMove",
            e.TouchEnd = "TouchEnd",
            e.OnRevNetData = "OnRevNetData",
            e.FrameChange = "FrameChange",
            e.SetScaleMode = "SetScaleMode",
            e.ChangeLang = "ChangeLang",
            e.NetOpen = "NetOpen",
            e.NetClose = "NetClose",
            e.FixScore = "FixScore",
            e.PlayerInfo = "PlayerInfo",
            e.NetMsg = "NetMsg",
            e.UserInfo = "UserInfo",
            e.ShowCreditBox = "ShowCreditBox",
            e.UpdateCredit = "UpdateCredit",
            e.ChangeHeadIcon = "ChangeHeadIcon",
            e.UpdateFavCards = "UpdateFavCards",
            e.ExitBrosePage = "ExitBrosePage",
            e.InitBrosePage = "InitBrosePage"
        }(n || (n = {})),
        o.MessageName = n;
        var r = function() {
            function e() {}
            return e.once = function(e, t, o) {
                this.eventTarget.once(e, t, o)
            }
            ,
            e.on = function(e, t, o) {
                this.eventTarget.on(e, t, o)
            }
            ,
            e.emit = function(e) {
                for (var t, o = [], n = 1; n < arguments.length; n++)
                    o[n - 1] = arguments[n];
                (t = this.eventTarget).emit.apply(t, i([e], o))
            }
            ,
            e.off = function(e, t, o) {
                this.eventTarget.off(e, t, o)
            }
            ,
            e.eventTarget = new cc.EventTarget,
            e
        }();
        o.MessageMgr = r,
        cc._RF.pop()
    }
    , {}],
    ModPwdBox: [function(e, t, o) {
        "use strict";
        cc._RF.push(t, "3de2aUVQ1RIfYqxR1cqoN2O", "ModPwdBox");
        var n, i = this && this.__extends || (n = function(e, t) {
            return (n = Object.setPrototypeOf || {
                __proto__: []
            }instanceof Array && function(e, t) {
                e.__proto__ = t
            }
            || function(e, t) {
                for (var o in t)
                    Object.prototype.hasOwnProperty.call(t, o) && (e[o] = t[o])
            }
            )(e, t)
        }
        ,
        function(e, t) {
            function o() {
                this.constructor = e
            }
            n(e, t),
            e.prototype = null === t ? Object.create(t) : (o.prototype = t.prototype,
            new o)
        }
        );
        Object.defineProperty(o, "__esModule", {
            value: !0
        }),
        o.ModPwdBox = void 0;
        var r = e("../config/Config")
          , a = e("../../base/SoundMgr")
          , s = e("../../base/LogicMgr")
          , c = e("../../base/common/view/Tip")
          , l = e("../../base/common/SpecialFunc")
          , f = e("../../base/common/MessageMgr")
          , h = e("../../base/net/EEvent")
          , d = e("../../base/res/DyncMgr")
          , u = e("../../base/common/Func")
          , p = e("../../base/net/NetMgr")
          , g = e("../../base/res/LanguageMgr")
          , _ = function(e) {
            function t() {
                return null !== e && e.apply(this, arguments) || this
            }
            return i(t, e),
            t.prototype.initParams = function() {
                e.prototype.initParams.call(this),
                this._popupMethod.root.getChildByName(s.ConstDefine.close).on(s.ConstDefine.click, this.close, this);
                var t = this._popupMethod.root.getChildByName("offsetX")
                  , o = t.getChildByName("old");
                this._oldNodeEdit = o.getComponent(cc.EditBox),
                l.default.editInput(o, this._popupMethod.root);
                var n = t.getChildByName("new");
                this._newNodeEdit = n.getComponent(cc.EditBox),
                l.default.editInput(n, this._popupMethod.root);
                var i = t.getChildByName("reEnter");
                this._reEnterNodeEdit = i.getComponent(cc.EditBox),
                l.default.editInput(i, this._popupMethod.root);
                var r = t.getChildByName("confirm");
                this._cfmBtn = r.getComponent(cc.Button),
                r.on(s.ConstDefine.click, this.confirm, this),
                s.default.useSoftKeyboard || (this._oldNodeEdit._impl._elem.autocomplete = "new-password",
                this._newNodeEdit._impl._elem.autocomplete = "new-password",
                this._reEnterNodeEdit._impl._elem.autocomplete = "new-password",
                o.on("editing-return", this.confirm, this),
                n.on("editing-return", this.confirm, this),
                i.on("editing-return", this.confirm, this))
            }
            ,
            t.prototype.resetParams = function() {
                this._oldNodeEdit.string = "",
                this._newNodeEdit.string = "",
                this._reEnterNodeEdit.string = "",
                s.default.useSoftKeyboard || (this._oldNodeEdit._impl._elem.style.visibility = "visible",
                this._newNodeEdit._impl._elem.style.visibility = "visible",
                this._reEnterNodeEdit._impl._elem.style.visibility = "visible"),
                e.prototype.resetParams.call(this),
                f.MessageMgr.on(f.MessageName.NetMsg, this.onLogonNet, this)
            }
            ,
            t.prototype.hide = function() {
                s.default.useSoftKeyboard || (this._oldNodeEdit._impl._elem.style.visibility = "hidden",
                this._newNodeEdit._impl._elem.style.visibility = "hidden",
                this._reEnterNodeEdit._impl._elem.style.visibility = "hidden"),
                e.prototype.hide.call(this)
            }
            ,
            t.prototype.close = function() {
                e.prototype.close.call(this),
                f.MessageMgr.off(f.MessageName.NetMsg, this.onLogonNet, this)
            }
            ,
            t.prototype.onLogonNet = function(e) {
                if (e.mainID === h.Cmd.MDM_MB_LOGON && e.subID == h.Cmd.SUB_MB_CHANGEPASSWORD_RESULT) {
                    var t = e.data;
                    d.default.getResInfo(s.ConstDefine.msgTip, g.default.procBsText(t.msg), 5, !0),
                    0 == t.result && (s.default.needReset = !1,
                    s.default.login.pwd = u.default.encryMd5(this._newPwdStr),
                    s.default.saveLoginData(),
                    "1" == localStorage.getItem(s.ConstDefine.remember) && localStorage.setItem(s.ConstDefine.savePwd, window.btoa(this._newPwdStr)),
                    this.hide()),
                    clearTimeout(this._cfmTimeOut),
                    this._cfmBtn.interactable = !0,
                    p.NetMgr.close()
                }
            }
            ,
            t.prototype.confirm = function() {
                var e = this;
                a.default.playEffect(s.ConstDefine.click);
                var t = this._oldNodeEdit.string;
                this._newPwdStr = this._newNodeEdit.string;
                var o = this._reEnterNodeEdit.string;
                if ("" !== t && "" !== this._newPwdStr && "" !== o) {
                    if (!s.default.login.testAcccount) {
                        if (this._newPwdStr.length < r.Config.accPwdMinLength || this._newPwdStr.length > r.Config.accPwdMaxLength)
                            return void d.default.getResInfo(s.ConstDefine.msgTip, g.default.procLangText("lengthTip"), 2, !0);
                        if (!new RegExp("(?=.*[0-9])(?=.*[a-zA-Z])").test(this._newPwdStr))
                            return void d.default.getResInfo(s.ConstDefine.msgTip, g.default.procLangText("pwdFormatTip"), 2, !0)
                    }
                    this._newPwdStr === o ? t !== this._newPwdStr ? s.default.login.succeed && (f.MessageMgr.once(f.MessageName.NetOpen, this.netOpen, this),
                    p.NetMgr.createWebSocket(),
                    this._cfmBtn.interactable = !1,
                    clearTimeout(this._cfmTimeOut),
                    this._cfmTimeOut = setTimeout(function() {
                        clearTimeout(e._cfmTimeOut),
                        e._cfmBtn.interactable = !0,
                        d.default.getResInfo(s.ConstDefine.msgTip, g.default.procLangText("badNetStatus")),
                        f.MessageMgr.off(f.MessageName.NetOpen, e.netOpen, e)
                    }, 5e3)) : d.default.getResInfo(s.ConstDefine.msgTip, g.default.procLangText("noSameTip"), 2, !0) : d.default.getResInfo(s.ConstDefine.msgTip, g.default.procLangText("pwdunlikeTip"), 2, !0)
                } else
                    d.default.getResInfo(s.ConstDefine.msgTip, g.default.procLangText("pwdNotEmptyTip"), 2, !0)
            }
            ,
            t.prototype.netOpen = function() {
                var e = {
                    userid: s.default.login.userID,
                    password: u.default.encryMd5(this._oldNodeEdit.string),
                    newpassword: u.default.encryMd5(this._newPwdStr),
                    dynamicpass: s.default.login.dynamicPass
                };
                p.NetMgr.send(h.Cmd.MDM_MB_LOGON, h.Cmd.SUB_MB_LOGON_CHANGEPASSWORD, e)
            }
            ,
            t
        }(c.PopupBase);
        o.ModPwdBox = _,
        cc._RF.pop()
    }
    , {
        "../../base/LogicMgr": "LogicMgr",
        "../../base/SoundMgr": "SoundMgr",
        "../../base/common/Func": "Func",
        "../../base/common/MessageMgr": "MessageMgr",
        "../../base/common/SpecialFunc": "SpecialFunc",
        "../../base/common/view/Tip": "Tip",
        "../../base/net/EEvent": "EEvent",
        "../../base/net/NetMgr": "NetMgr",
        "../../base/res/DyncMgr": "DyncMgr",
        "../../base/res/LanguageMgr": "LanguageMgr",
        "../config/Config": "Config"
    }],
    MsgPromptBox: [function(e, t, o) {
        "use strict";
        cc._RF.push(t, "77abeXLtDVEs7UPB8dFdojm", "MsgPromptBox");
        var n, i = this && this.__extends || (n = function(e, t) {
            return (n = Object.setPrototypeOf || {
                __proto__: []
            }instanceof Array && function(e, t) {
                e.__proto__ = t
            }
            || function(e, t) {
                for (var o in t)
                    Object.prototype.hasOwnProperty.call(t, o) && (e[o] = t[o])
            }
            )(e, t)
        }
        ,
        function(e, t) {
            function o() {
                this.constructor = e
            }
            n(e, t),
            e.prototype = null === t ? Object.create(t) : (o.prototype = t.prototype,
            new o)
        }
        );
        Object.defineProperty(o, "__esModule", {
            value: !0
        }),
        o.ExitPromptBox = void 0;
        var r = e("../../base/common/view/Tip")
          , a = e("../../base/LogicMgr")
          , s = function(e) {
            function t() {
                return null !== e && e.apply(this, arguments) || this
            }
            return i(t, e),
            t.prototype.initParams = function() {
                e.prototype.initParams.call(this);
                var t = this._popupMethod.root.getChildByName("adjustX").getChildByName("tip");
                this._textTip = t.getChildByName("text").getComponent(cc.Label),
                this.regeditBtn()
            }
            ,
            t.prototype.resetParams = function(t) {
                e.prototype.resetParams.call(this),
                this._textTip.string = t
            }
            ,
            t.prototype.regeditBtn = function() {
                this._popupMethod.root.getChildByName(a.ConstDefine.close).on(a.ConstDefine.click, this.close, this),
                this._popupMethod.root.getChildByName("adjustX").getChildByName("btnConfirm").on(a.ConstDefine.click, this.close, this)
            }
            ,
            t.prototype.isReset = function() {
                return !0
            }
            ,
            t
        }(r.PopupBase);
        o.default = s;
        var c = function(e) {
            function t() {
                return null !== e && e.apply(this, arguments) || this
            }
            return i(t, e),
            t.prototype.regeditBtn = function() {
                this._popupMethod.root.getChildByName(a.ConstDefine.close).on(a.ConstDefine.click, this.close, this),
                this._popupMethod.root.getChildByName("adjustX").getChildByName("btnConfirm").on(a.ConstDefine.click, this.exitConfirm, this)
            }
            ,
            t.prototype.exitConfirm = function() {
                a.default.exitLogin(),
                this.close()
            }
            ,
            t
        }(s);
        o.ExitPromptBox = c,
        cc._RF.pop()
    }
    , {
        "../../base/LogicMgr": "LogicMgr",
        "../../base/common/view/Tip": "Tip"
    }],
    MutabEffectCfg: [function(e, t, o) {
        "use strict";
        cc._RF.push(t, "344e4047dpMtaUjpG6xOKdG", "MutabEffectCfg"),
        Object.defineProperty(o, "__esModule", {
            value: !0
        }),
        o.TextCfg = o.MutabEffectCfg = void 0,
        o.MutabEffectCfg = {
            type: {}
        },
        o.TextCfg = {
            weapon: {
                scale: .4
            },
            golden: {
                spacingX: -18
            },
            score: {
                spacingX: -10
            },
            zhadanxie: {
                spacingX: -10
            }
        },
        cc._RF.pop()
    }
    , {}],
    MutabResCfg: [function(e, t, o) {
        "use strict";
        cc._RF.push(t, "dbeeacVy9RNKq1fq3E685uc", "MutabResCfg"),
        Object.defineProperty(o, "__esModule", {
            value: !0
        }),
        o.DyncResCfg = void 0;
        var n = e("../../base/common/view/NodeHandle")
          , i = e("./Config")
          , r = e("../../base/res/DyncAnimPlay")
          , a = e("../view/HallUI")
          , s = e("../view/LoginUI")
          , c = e("../../base/res/ResCfg")
          , l = e("../view/HeadUI")
          , f = e("../view/NoticeTip")
          , h = e("../view/ModPwdBox")
          , d = e("../view/SettingBox")
          , u = e("../view/JpUI")
          , p = e("../view/JpRankUI")
          , g = e("../../base/common/view/Tip")
          , _ = e("../../base/res/ParticlePlay")
          , y = e("../../base/res/DyncLoadedBase")
          , m = e("../view/MsgPromptBox")
          , v = e("../view/BigAdvertUI")
          , b = e("../view/AdvertUI")
          , C = e("../view/ShareUI")
          , M = e("../view/KeyboardUI")
          , S = e("../../base/debug/DebugMgr")
          , w = e("../view/PcFullScreenUI")
          , N = e("../view/RollPrize")
          , B = e("../../base/LogicMgr")
          , P = e("../view/CashbackUI")
          , k = e("../view/Notice");
        o.DyncResCfg = {
            loadingTip: {
                type: c.DyncInfoType.singleNode,
                path: "prefabs/loadingTip",
                nodeCfg: {
                    handle: n.NodeHandleType.none,
                    layer: i.AdaptLevel.loadTip,
                    class: g.AutoHideTip
                }
            },
            loginUI: {
                loadingTip: !0,
                type: c.DyncInfoType.singleNode,
                path: "prefabs/loginUI",
                nodeCfg: {
                    handle: n.NodeHandleType.active,
                    layer: i.AdaptLevel.loginUI,
                    class: s.LoginUI
                }
            },
            hallUI: {
                loadingTip: !0,
                type: c.DyncInfoType.singleNode,
                path: "prefabs/hallUI",
                nodeCfg: {
                    layer: i.AdaptLevel.hallUI,
                    class: a.default
                }
            },
            rollPrize: {
                loadingTip: !0,
                type: c.DyncInfoType.singleNode,
                path: "prefabs/rollPrize",
                nodeCfg: {
                    layer: i.AdaptLevel.msgTip,
                    class: N.default
                }
            },
            headUI: {
                loadingTip: !0,
                type: c.DyncInfoType.singleNode,
                path: "prefabs/headUI",
                nodeCfg: {
                    handle: n.NodeHandleType.active,
                    layer: i.AdaptLevel.msgTip,
                    class: l.HeadUI
                }
            },
            keyboardUI: {
                loadingTip: !0,
                type: c.DyncInfoType.singleNode,
                path: "prefabs/softKeyboard",
                nodeCfg: {
                    handle: n.NodeHandleType.active,
                    layer: i.AdaptLevel.keyboardUI,
                    class: M.default
                }
            },
            jpUI: {
                loadingTip: !0,
                type: c.DyncInfoType.singleNode,
                path: "prefabs/jpUI",
                nodeCfg: {
                    handle: n.NodeHandleType.active,
                    layer: i.AdaptLevel.jpUI,
                    class: u.default
                }
            },
            msgTip: {
                preLoad: !0,
                type: c.DyncInfoType.singleNode,
                path: "prefabs/msgTip",
                nodeCfg: {
                    handle: n.NodeHandleType.active,
                    layer: i.AdaptLevel.msgTip2,
                    class: g.AutoHideTextTip
                }
            },
            noticeTip: {
                type: c.DyncInfoType.singleNode,
                path: "prefabs/noticeTip",
                nodeCfg: {
                    handle: n.NodeHandleType.active,
                    layer: i.AdaptLevel.msgTip,
                    class: f.NoticeTip
                }
            },
            notice: {
                type: c.DyncInfoType.singleNode,
                path: "prefabs/notice",
                nodeCfg: {
                    handle: n.NodeHandleType.active,
                    layer: i.AdaptLevel.msgTip2,
                    class: k.default
                }
            },
            jpRankUI: {
                loadingTip: !0,
                type: c.DyncInfoType.singleNode,
                path: "prefabs/jpRankUI",
                nodeCfg: {
                    handle: n.NodeHandleType.active,
                    layer: i.AdaptLevel.jpUI,
                    class: p.default
                }
            },
            msgPromptBox: {
                type: c.DyncInfoType.singleNode,
                path: "prefabs/msgPromptBox",
                nodeCfg: {
                    handle: n.NodeHandleType.active,
                    layer: i.AdaptLevel.msgTip,
                    class: m.default
                }
            },
            exitPromptBox: {
                type: c.DyncInfoType.singleNode,
                path: "prefabs/msgPromptBox",
                nodeCfg: {
                    handle: n.NodeHandleType.active,
                    layer: i.AdaptLevel.msgTip,
                    class: m.ExitPromptBox
                }
            },
            modPwdBox: {
                type: c.DyncInfoType.singleNode,
                path: "prefabs/modPwdBox",
                nodeCfg: {
                    handle: n.NodeHandleType.active,
                    layer: i.AdaptLevel.msgTip,
                    class: h.ModPwdBox
                }
            },
            settingBox: {
                type: c.DyncInfoType.singleNode,
                path: "prefabs/settingBox",
                nodeCfg: {
                    handle: n.NodeHandleType.active,
                    layer: i.AdaptLevel.msgTip,
                    class: d.SettingBox
                }
            },
            shareUI: {
                type: c.DyncInfoType.singleNode,
                path: "prefabs/shareUI",
                nodeCfg: {
                    handle: n.NodeHandleType.active,
                    layer: i.AdaptLevel.msgTip,
                    class: C.ShareUI
                }
            },
            advert: {
                type: c.DyncInfoType.singleNode,
                path: "prefabs/advert",
                nodeCfg: {
                    handle: n.NodeHandleType.active,
                    class: b.AdvertUI
                }
            },
            pcFullScreenUI: {
                type: c.DyncInfoType.singleNode,
                path: "prefabs/pcFullScreenUI",
                nodeCfg: {
                    handle: n.NodeHandleType.active,
                    layer: i.AdaptLevel.jpUI,
                    class: w.default
                }
            },
            bigAdvertUI: {
                type: c.DyncInfoType.singleNode,
                path: "prefabs/bigAdvertUI",
                nodeCfg: {
                    handle: n.NodeHandleType.active,
                    layer: i.AdaptLevel.msgTip,
                    class: v.default
                }
            },
            cashbackUI: {
                type: c.DyncInfoType.singleNode,
                path: "prefabs/cashbackUI",
                nodeCfg: {
                    handle: n.NodeHandleType.active,
                    layer: i.AdaptLevel.loginUI,
                    class: P.default
                }
            },
            click: {
                type: c.DyncInfoType.mulNode,
                path: "anim/click",
                nodeCfg: {
                    handle: n.NodeHandleType.opacity,
                    layer: i.AdaptLevel.clickTip,
                    class: r.default
                }
            },
            bounderyMask: {
                type: c.DyncInfoType.singleNode,
                path: "prefabs/bounderyMask",
                nodeCfg: {
                    layer: i.AdaptLevel.bounderyMask
                }
            },
            debugPanel: {
                type: c.DyncInfoType.singleNode,
                path: "prefabs/debugPanel",
                nodeCfg: {
                    layer: i.AdaptLevel.debug,
                    class: S.default
                }
            }
        };
        for (var R = [], T = 0, I = R; T < I.length; T++) {
            var D = I[T];
            o.DyncResCfg[D] = {
                type: c.DyncInfoType.mulNode,
                path: "particle/" + D,
                nodeCfg: {
                    level: 1,
                    handle: n.NodeHandleType.active,
                    class: _.default
                }
            }
        }
        for (var L = 0, x = R = []; L < x.length; L++) {
            var E = x[L];
            o.DyncResCfg[E] = {
                type: c.DyncInfoType.singleNode,
                path: "prefabs/" + E
            }
        }
        for (var O = 0, F = R = []; O < F.length; O++)
            E = F[O],
            o.DyncResCfg[E] = {
                type: c.DyncInfoType.singleNode,
                loadIndex: 1,
                path: "prefabs/" + E,
                nodeCfg: {
                    class: y.DyncSetParent
                }
            };
        for (var A = 0, j = R = ["card", "singleToggle", "singleToggleA", "singleToggleB", B.ConstDefine.textMgr]; A < j.length; A++)
            E = j[A],
            o.DyncResCfg[E] = {
                type: c.DyncInfoType.singleNode,
                path: "prefabs/" + E,
                nodeCfg: {
                    handle: n.NodeHandleType.active
                }
            };
        for (var U = 0, G = R = []; U < G.length; U++)
            E = G[U],
            o.DyncResCfg[E] = {
                type: c.DyncInfoType.mulNode,
                path: "prefabs/" + E,
                nodeCfg: {
                    handle: n.NodeHandleType.pos
                }
            };
        for (var H = 0, z = R = ["announcement", "music", "setting", "sound", "music1", "music2", "music3", "music4", "music5", "music6", "randomPlay", "binddevice", "unboundA", "unboundB", "jpRecord", "total", "grand", "major", "minor", "mini", "order", "userID", "jackpot", "time", "bounus", "noData", "noRecordLst", "ranking"]; H < z.length; H++)
            E = z[H],
            o.DyncResCfg[E] = {
                loadMode: c.DyncLoadMode.language,
                loadType: cc.SpriteFrame,
                path: E
            };
        for (var V = 0, W = R = []; V < W.length; V++)
            E = W[V],
            o.DyncResCfg[E] = {
                loadType: cc.Prefab,
                loadMode: c.DyncLoadMode.language,
                path: E
            };
        R = null,
        cc._RF.pop()
    }
    , {
        "../../base/LogicMgr": "LogicMgr",
        "../../base/common/view/NodeHandle": "NodeHandle",
        "../../base/common/view/Tip": "Tip",
        "../../base/debug/DebugMgr": "DebugMgr",
        "../../base/res/DyncAnimPlay": "DyncAnimPlay",
        "../../base/res/DyncLoadedBase": "DyncLoadedBase",
        "../../base/res/ParticlePlay": "ParticlePlay",
        "../../base/res/ResCfg": "ResCfg",
        "../view/AdvertUI": "AdvertUI",
        "../view/BigAdvertUI": "BigAdvertUI",
        "../view/CashbackUI": "CashbackUI",
        "../view/HallUI": "HallUI",
        "../view/HeadUI": "HeadUI",
        "../view/JpRankUI": "JpRankUI",
        "../view/JpUI": "JpUI",
        "../view/KeyboardUI": "KeyboardUI",
        "../view/LoginUI": "LoginUI",
        "../view/ModPwdBox": "ModPwdBox",
        "../view/MsgPromptBox": "MsgPromptBox",
        "../view/Notice": "Notice",
        "../view/NoticeTip": "NoticeTip",
        "../view/PcFullScreenUI": "PcFullScreenUI",
        "../view/RollPrize": "RollPrize",
        "../view/SettingBox": "SettingBox",
        "../view/ShareUI": "ShareUI",
        "./Config": "Config"
    }],
    MutabTextDesc: [function(e, t, o) {
        "use strict";
        cc._RF.push(t, "8379aR0k1RIlKLtaAAnwPc7", "MutabTextDesc"),
        Object.defineProperty(o, "__esModule", {
            value: !0
        }),
        o.TextCfg = o.MutabLangText = o.OptLangRes = o.LangRes = void 0,
        o.LangRes = [],
        o.OptLangRes = {
            fish: []
        },
        o.MutabLangText = {
            sp: {
                grand: "Grandioso",
                major: "Mayor",
                minor: "Menor",
                mini: "Mini",
                getPrize: "Obtuve un premio %s con %s en %s",
                pwdFormatTip: "La nueva contrase\xf1a deberia ser de 6 o m\xe1s caracteres, incluyendo una letra y un n\xfamero.",
                pwdunlikeTip: "Las dos contrase\xf1as que ingres\xf3 eran inconsistentes.",
                noSameTip: "La nueva contrase\xf1a no puede ser la misma que la contrase\xf1a anterior.",
                forgetTip: "P\xf3ngase en contacto con el servicio al cliente para recuperar la contrase\xf1a",
                changePwdTip: "La nueva contrase\xf1a debe ser modificada",
                maintenanceTip: "Condici\xf3n del mantenimiento",
                commingTip: "El juego va a venir en l\xednea, \xa1esperen con ansias!",
                badNetStatus: "Servidor ocupado trata mas tarde",
                enterGameError: "No mesa",
                exitLogin: "Salir del inicio de sesi\xf3n?",
                accountEmptyTip: "\xa1El nombre de usuario no puede estar vac\xedo!",
                pwdEmptyTip: "\xa1La contrase\xf1a no puede estar en blanco!",
                pwdNotEmptyTip: "\xa1La contrase\xf1a no puede estar en blanco!!!",
                lengthTip: "La cuenta o contrase\xf1a debe tener entre 6 y 32 caracteres.",
                paste: "pega tu contenido aqu\xed:",
                pressPaste: "presione largo para pegar el contenido:",
                Close: "Cerrar"
            },
            en: {
                username: "user name:",
                password: "password:",
                login: "login",
                loginTip: "Wrong user name or password",
                homepage: "HOME",
                games: "Games",
                download: "Download",
                aboutUs: "ABOUT",
                all_games: "ALL",
                new: "NEW",
                fishing_games: "FISHING",
                slot_games: "SLOT",
                others: "OTHERS",
                favorite: "FAVORITE",
                cancle: "cancle",
                sure: "ok",
                errorTip: "ERROR",
                required: "Required",
                notRunning: "The current game is not running",
                searchTip: "Find a game",
                paste: "paste your content here:",
                pressPaste: "long press to paste your content:",
                Close: "Close"
            }
        },
        o.TextCfg = {
            weapon: {
                scale: .4
            },
            golden: {
                spacingX: -18
            },
            score: {
                spacingX: -10
            },
            zhadanxie: {
                spacingX: -10
            }
        },
        cc._RF.pop()
    }
    , {}],
    NetMgr: [function(e, t, o) {
        "use strict";
        cc._RF.push(t, "9091dhAsSVLkLxhqEW+WOhW", "NetMgr"),
        Object.defineProperty(o, "__esModule", {
            value: !0
        }),
        o.NetMgr = o.TipProExt = o.HttpGetProto = void 0;
        var n, i = e("../common/MessageMgr"), r = e("../../my/config/Config"), a = e("../res/DyncMgr"), s = e("../LogicMgr"), c = e("../res/LanguageMgr");
        (function(e) {
            e[e.json = 0] = "json",
            e[e.string = 1] = "string"
        }
        )(n = o.HttpGetProto || (o.HttpGetProto = {})),
        function(e) {
            e[e.kick = 0] = "kick",
            e[e.stoppplay = 1] = "stoppplay",
            e[e.maintain = 2] = "maintain",
            e[e.keepGoing = 3] = "keepGoing",
            e[e.tip = 100] = "tip",
            e[e.bc = 101] = "bc"
        }(o.TipProExt || (o.TipProExt = {}));
        var l = function() {
            function e() {}
            return e.reconnect = function(e) {
                void 0 === e && (e = !1),
                a.default.getResInfo(s.ConstDefine.msgTip, c.default.procLangText("badNetStatus"))
            }
            ,
            e.createWebSocket = function() {
                if (this.close(),
                navigator.onLine)
                    try {
                        this._socket = new WebSocket(r.Config.wsUrl,r.Config.wsProtocol),
                        this._socket.onclose = this.onClose.bind(this),
                        this._socket.onopen = this.onOpen.bind(this),
                        this._socket.onmessage = this.onMessage.bind(this),
                        this._socket.onerror = this.onError.bind(this)
                    } catch (e) {
                        this.reconnect()
                    }
                else
                    this.reconnect()
            }
            ,
            e.onMessage = function(e) {
                var t = JSON.parse(e.data);
                i.MessageMgr.emit(i.MessageName.NetMsg, t)
            }
            ,
            e.clearConnectTimeOut = function() {
                null != this._connectTimeout && (clearTimeout(this._connectTimeout),
                this._connectTimeout = void 0)
            }
            ,
            e.close = function() {
                this.clearConnectTimeOut(),
                this._socket && (this._socket.readyState === WebSocket.CLOSED && navigator.onLine || this._socket.close(),
                this._socket.onopen = null),
                this._socket = null
            }
            ,
            e.onOpen = function() {
                i.MessageMgr.emit(i.MessageName.NetOpen)
            }
            ,
            e.onClose = function() {
                this.clearConnectTimeOut(),
                i.MessageMgr.emit(i.MessageName.NetClose)
            }
            ,
            e.onError = function(e) {
                console.error(e)
            }
            ,
            e.isOpen = function() {
                return !!this._socket && this._socket.readyState === WebSocket.OPEN
            }
            ,
            e.send = function(e, t, o) {
                this.isOpen() ? (o.mainID = e,
                o.subID = t,
                this._socket.send(JSON.stringify(o))) : a.default.getResInfo(s.ConstDefine.msgTip, c.default.procLangText("badNetStatus"))
            }
            ,
            e.sendCmd = function(e, t) {
                this.send(e, t, {})
            }
            ,
            e.sendHttpGet = function(e, t, o) {
                void 0 === o && (o = n.json);
                var i = new XMLHttpRequest;
                i.open("GET", e, !0),
                i.onreadystatechange = function() {
                    if (4 == i.readyState && i.status >= 200 && i.status < 300) {
                        var e = i.responseText;
                        switch (o) {
                        case n.json:
                            t(JSON.parse(e));
                            break;
                        case n.string:
                            t(e)
                        }
                    }
                }
                ,
                i.send()
            }
            ,
            e._connectTimeout = void 0,
            e
        }();
        o.NetMgr = l,
        cc._RF.pop()
    }
    , {
        "../../my/config/Config": "Config",
        "../LogicMgr": "LogicMgr",
        "../common/MessageMgr": "MessageMgr",
        "../res/DyncMgr": "DyncMgr",
        "../res/LanguageMgr": "LanguageMgr"
    }],
    NoColorSprite: [function(e, t) {
        "use strict";
        cc._RF.push(t, "c8774gIF6dInYkbWFo9tcUk", "NoColorSprite"),
        cc._RF.pop()
    }
    , {}],
    NodeHandle: [function(e, t, o) {
        "use strict";
        cc._RF.push(t, "edb303Cu01LN6uic5aJRPCn", "NodeHandle");
        var n, i = this && this.__extends || (n = function(e, t) {
            return (n = Object.setPrototypeOf || {
                __proto__: []
            }instanceof Array && function(e, t) {
                e.__proto__ = t
            }
            || function(e, t) {
                for (var o in t)
                    Object.prototype.hasOwnProperty.call(t, o) && (e[o] = t[o])
            }
            )(e, t)
        }
        ,
        function(e, t) {
            function o() {
                this.constructor = e
            }
            n(e, t),
            e.prototype = null === t ? Object.create(t) : (o.prototype = t.prototype,
            new o)
        }
        );
        Object.defineProperty(o, "__esModule", {
            value: !0
        }),
        o.createNodeHandle = o.NodeHandle = o.NodeHandleType = void 0;
        var r, a = e("../../../my/config/Config");
        (function(e) {
            e[e.none = 0] = "none",
            e[e.opacity = 1] = "opacity",
            e[e.active = 2] = "active",
            e[e.inactive = 3] = "inactive",
            e[e.pos = 4] = "pos"
        }
        )(r = o.NodeHandleType || (o.NodeHandleType = {}));
        var s = function() {
            function e() {}
            return e.prototype.reset = function() {}
            ,
            e.prototype.clear = function() {}
            ,
            e.prototype.isReset = function() {
                return !1
            }
            ,
            e
        }();
        o.NodeHandle = s;
        var c = function(e) {
            function t() {
                return null !== e && e.apply(this, arguments) || this
            }
            return i(t, e),
            t.prototype.reset = function(e) {
                e.opacity = 255
            }
            ,
            t.prototype.clear = function(e) {
                e.opacity = 0
            }
            ,
            t.prototype.isReset = function(e) {
                return 0 === e.opacity
            }
            ,
            t
        }(s)
          , l = function(e) {
            function t() {
                return null !== e && e.apply(this, arguments) || this
            }
            return i(t, e),
            t.prototype.reset = function(e) {
                e.active = !0
            }
            ,
            t.prototype.clear = function(e) {
                e.active = !1
            }
            ,
            t.prototype.isReset = function(e) {
                return !e.active
            }
            ,
            t
        }(s)
          , f = function(e) {
            function t() {
                return null !== e && e.apply(this, arguments) || this
            }
            return i(t, e),
            t.prototype.reset = function(e) {
                e.active = !1
            }
            ,
            t
        }(l)
          , h = function(e) {
            function t() {
                var t = null !== e && e.apply(this, arguments) || this;
                return t._initPos = cc.Vec3.ZERO,
                t
            }
            return i(t, e),
            t.prototype.reset = function(e) {
                e.setPosition(this._initPos),
                e.active = !0
            }
            ,
            t.prototype.clear = function(e) {
                this._initPos.set(e.position),
                e.setPosition(a.Config.outScreenPos)
            }
            ,
            t.prototype.isReset = function(e) {
                return e.position.equals(a.Config.outScreenPos)
            }
            ,
            t
        }(s);
        o.createNodeHandle = function(e) {
            var t = null;
            switch (e) {
            case r.opacity:
                t = new c;
                break;
            case r.inactive:
                t = new f;
                break;
            case r.pos:
                t = new h;
                break;
            case r.none:
                t = new s;
                break;
            default:
                t = new l
            }
            return t
        }
        ,
        cc._RF.pop()
    }
    , {
        "../../../my/config/Config": "Config"
    }],
    NoticeTip: [function(e, t, o) {
        "use strict";
        cc._RF.push(t, "3a2faMXhDNMvoNEh1ntHcuV", "NoticeTip");
        var n, i = this && this.__extends || (n = function(e, t) {
            return (n = Object.setPrototypeOf || {
                __proto__: []
            }instanceof Array && function(e, t) {
                e.__proto__ = t
            }
            || function(e, t) {
                for (var o in t)
                    Object.prototype.hasOwnProperty.call(t, o) && (e[o] = t[o])
            }
            )(e, t)
        }
        ,
        function(e, t) {
            function o() {
                this.constructor = e
            }
            n(e, t),
            e.prototype = null === t ? Object.create(t) : (o.prototype = t.prototype,
            new o)
        }
        );
        Object.defineProperty(o, "__esModule", {
            value: !0
        }),
        o.NoticeTip = void 0;
        var r = e("../../base/common/view/Tip")
          , a = e("../../base/res/DyncLoadedBase")
          , s = e("../../base/SoundMgr")
          , c = e("../../base/LogicMgr")
          , l = e("../../base/res/LanguageMgr")
          , f = function(e) {
            function t() {
                var t = null !== e && e.apply(this, arguments) || this;
                return t._langSpt = new a.DyncLangSprite,
                t
            }
            return i(t, e),
            t.prototype.initParams = function() {
                e.prototype.initParams.call(this),
                this._popupMethod.root.getChildByName(c.ConstDefine.close).on(c.ConstDefine.click, this.close, this);
                var t = this._popupMethod.root.getChildByName("offsetX");
                this._content = t.getChildByName("content").getComponent(cc.Label)
            }
            ,
            t.prototype.resetParams = function() {
                e.prototype.resetParams.call(this),
                c.default.login.mainContent.length > 0 && this.setContent(0)
            }
            ,
            t.prototype.setContent = function(e) {
                this._lastIndex = e,
                this._content.string = l.default.procBsText(c.default.login.mainContent[this._lastIndex].maincontent)
            }
            ,
            t.prototype.toggleClick = function(e) {
                s.default.playEffect(c.ConstDefine.click),
                e !== this._lastIndex && this.setContent(e)
            }
            ,
            t
        }(r.PopupBase);
        o.NoticeTip = f,
        cc._RF.pop()
    }
    , {
        "../../base/LogicMgr": "LogicMgr",
        "../../base/SoundMgr": "SoundMgr",
        "../../base/common/view/Tip": "Tip",
        "../../base/res/DyncLoadedBase": "DyncLoadedBase",
        "../../base/res/LanguageMgr": "LanguageMgr"
    }],
    Notice: [function(e, t, o) {
        "use strict";
        cc._RF.push(t, "3200apqfFNJWbqfPv6i3SyO", "Notice");
        var n, i = this && this.__extends || (n = function(e, t) {
            return (n = Object.setPrototypeOf || {
                __proto__: []
            }instanceof Array && function(e, t) {
                e.__proto__ = t
            }
            || function(e, t) {
                for (var o in t)
                    Object.prototype.hasOwnProperty.call(t, o) && (e[o] = t[o])
            }
            )(e, t)
        }
        ,
        function(e, t) {
            function o() {
                this.constructor = e
            }
            n(e, t),
            e.prototype = null === t ? Object.create(t) : (o.prototype = t.prototype,
            new o)
        }
        );
        Object.defineProperty(o, "__esModule", {
            value: !0
        });
        var r = e("../../base/common/view/Tip")
          , a = e("../../base/res/LanguageMgr")
          , s = e("../config/Config")
          , c = function(e) {
            function t() {
                return null !== e && e.apply(this, arguments) || this
            }
            return i(t, e),
            t.prototype.initParams = function() {
                e.prototype.initParams.call(this),
                this._titleRichText = this._popupMethod.root.getChildByName("title").getComponent(cc.RichText),
                this._contentRichText = this._popupMethod.root.getChildByName("content").getComponent(cc.RichText);
                var t = this._popupMethod.root.getChildByName("close");
                t.on("click", this.close, this),
                this._closeLabel = t.getChildByName("label").getComponent(cc.Label),
                this._popupMethod.root.getChildByName("visit").on("click", this.visit, this)
            }
            ,
            t.prototype.resetParams = function() {
                for (var t = [], o = 0; o < arguments.length; o++)
                    t[o] = arguments[o];
                e.prototype.resetParams.call(this),
                this._closeLabel.string = a.default.procLangText("Close"),
                this._titleRichText.string = s.Config.VisitNotice[a.default.currLang].title,
                this._contentRichText.string = s.Config.VisitNotice[a.default.currLang].msg
            }
            ,
            t.prototype.visit = function() {
                window.open(s.Config.VisitNotice.toHttp, "_blank"),
                this.close()
            }
            ,
            t
        }(r.PopupBase);
        o.default = c,
        cc._RF.pop()
    }
    , {
        "../../base/common/view/Tip": "Tip",
        "../../base/res/LanguageMgr": "LanguageMgr",
        "../config/Config": "Config"
    }],
    PageView: [function(e, t, o) {
        "use strict";
        cc._RF.push(t, "d5595HwvidDkJm6chwHhLpH", "PageView");
        var n, i = this && this.__extends || (n = function(e, t) {
            return (n = Object.setPrototypeOf || {
                __proto__: []
            }instanceof Array && function(e, t) {
                e.__proto__ = t
            }
            || function(e, t) {
                for (var o in t)
                    Object.prototype.hasOwnProperty.call(t, o) && (e[o] = t[o])
            }
            )(e, t)
        }
        ,
        function(e, t) {
            function o() {
                this.constructor = e
            }
            n(e, t),
            e.prototype = null === t ? Object.create(t) : (o.prototype = t.prototype,
            new o)
        }
        );
        Object.defineProperty(o, "__esModule", {
            value: !0
        }),
        o.LoopTogglePageView = o.TogglePageView = o.LeftRightDouble = o.RightShowBtn = o.LeftRightBtn = o.LeftRightOnly = o.BtnControl = o.BtnControlType = void 0;
        var r, a = e("../../effect/EffectMgr"), s = e("../../LogicMgr"), c = e("../../res/DyncMgr"), l = e("../../SoundMgr");
        (function(e) {
            e[e.normal = 0] = "normal",
            e[e.leftRightSeq = 1] = "leftRightSeq",
            e[e.rightShow = 2] = "rightShow",
            e[e.leftRightDouble = 3] = "leftRightDouble"
        }
        )(r = o.BtnControlType || (o.BtnControlType = {}));
        var f = function() {
            function e(e) {
                this._pgView = e
            }
            return e.prototype.pageChange = function() {}
            ,
            e.prototype.resetPageCnt = function() {}
            ,
            e
        }();
        o.BtnControl = f;
        var h = function(e) {
            function t() {
                return null !== e && e.apply(this, arguments) || this
            }
            return i(t, e),
            t
        }(f);
        o.LeftRightOnly = h;
        var d = function(e) {
            function t(t, o) {
                var n = e.call(this, t, o) || this;
                return n._leftBtnNode = o.root.getChildByName("leftBtn"),
                n._leftBtnNode.on(s.ConstDefine.click, n.leftClick, n),
                n._leftBtnNode.active = !0,
                n._rightBtnNode = o.root.getChildByName("rightBtn"),
                n._rightBtnNode.on(s.ConstDefine.click, n.rightClick, n),
                n._rightBtnNode.active = !0,
                n
            }
            return i(t, e),
            t.prototype.pageChange = function() {
                this._rightBtnNode.active = !0,
                this._leftBtnNode.active = !0,
                this._pgView.isBegin() && (this._leftBtnNode.active = !1),
                this._pgView.isEnd() && (this._rightBtnNode.active = !1)
            }
            ,
            t.prototype.leftClick = function() {
                l.default.playEffect("winslide"),
                this._pgView.lastPg(),
                this._rightBtnNode.active = !0,
                this._pgView.isBegin() && (this._leftBtnNode.active = !1)
            }
            ,
            t.prototype.rightClick = function() {
                l.default.playEffect("winslide"),
                this._pgView.nextPg(),
                this._leftBtnNode.active = !0,
                this._pgView.isEnd() && (this._rightBtnNode.active = !1)
            }
            ,
            t
        }(h);
        o.LeftRightBtn = d;
        var u, p, g = function(e) {
            function t(t, o) {
                var n = e.call(this, t, o) || this;
                return n._leftBtnNode = o.leftNode || o.root.getChildByName("leftBtn"),
                n._leftBtnNode.on(s.ConstDefine.click, n.leftClick, n),
                n._leftBtnNode.active = !1,
                n._rightBtnNode = o.rightNode || o.root.getChildByName("rightBtn"),
                n._rightBtnNode.on(s.ConstDefine.click, n.rightClick, n),
                n._rightBtnNode.active = !1,
                n
            }
            return i(t, e),
            t.prototype.resetPageCnt = function(e) {
                e <= 1 && (this._leftBtnNode.active = !1,
                this._rightBtnNode.active = !1)
            }
            ,
            t.prototype.pageChange = function() {
                this._pgView.pageCount <= 1 || (this._pgView.isEnd() ? (this._rightBtnNode.active = !1,
                this._leftBtnNode.active = !0) : (this._rightBtnNode.active = !0,
                this._leftBtnNode.active = !1))
            }
            ,
            t.prototype.leftClick = function() {
                l.default.playEffect("winslide"),
                this._pgView.lastPg(),
                this._pgView.isEnd() || (this._rightBtnNode.active = !0,
                this._leftBtnNode.active = !1)
            }
            ,
            t.prototype.rightClick = function() {
                l.default.playEffect("winslide"),
                this._pgView.nextPg(),
                this._pgView.isEnd() && (this._rightBtnNode.active = !1,
                this._leftBtnNode.active = !0)
            }
            ,
            t
        }(h);
        o.RightShowBtn = g,
        function(e) {
            e[e.last = 0] = "last",
            e[e.next = 1] = "next",
            e[e.num = 2] = "num"
        }(u || (u = {})),
        function(e) {
            e[e.last = 0] = "last",
            e[e.next = 1] = "next",
            e[e.num = 2] = "num"
        }(p || (p = {}));
        var _ = function(e) {
            function t(t, o) {
                var n = e.call(this, t, o) || this;
                n._btnNode = [],
                n._defaultShowNode = [],
                n._defaultHideNode = [];
                for (var i = 0; i < u.num; ++i)
                    n._btnNode[i] = [];
                var r = o.leftNode || o.root.getChildByName("leftBtn");
                r.active = !0;
                var a = r.getChildByName("last");
                n._btnNode[u.last].push(a),
                n._defaultShowNode.push(a);
                var c = r.getChildByName("next");
                n._btnNode[u.next][p.last] = c,
                n._defaultHideNode.push(c);
                var l = o.rightNode || o.root.getChildByName("rightBtn");
                l.active = !0,
                a = l.getChildByName("last"),
                n._btnNode[u.last][p.next] = a,
                n._defaultHideNode.push(a),
                c = l.getChildByName("next"),
                n._btnNode[u.next][p.next] = c,
                n._defaultShowNode.push(c);
                var f = n._btnNode[u.last];
                for (i = 0; i < f.length; ++i)
                    f[i].on(s.ConstDefine.click, n.lastClick, n),
                    f[i].active = !1;
                var h = n._btnNode[u.next];
                for (i = 0; i < h.length; ++i)
                    h[i].on(s.ConstDefine.click, n.nextClick, n),
                    h[i].active = !1;
                return n
            }
            return i(t, e),
            t.prototype.resetPageCnt = function(e) {
                if (e <= 1)
                    for (var t = 0; t < u.num - 1; ++t)
                        for (var o = 0; o < p.num - 1; ++o)
                            this._btnNode[t][o].active = !1
            }
            ,
            t.prototype.pageChange = function() {
                if (!(this._pgView.pageCount <= 1))
                    if (this._pgView.isEnd()) {
                        for (var e = this._btnNode[u.last], t = 0; t < e.length; ++t)
                            e[t].active = !0;
                        var o = this._btnNode[u.next];
                        for (t = 0; t < o.length; ++t)
                            o[t].active = !1
                    } else
                        this._pgView.isBegin()
            }
            ,
            t.prototype.lastClick = function() {
                l.default.playEffect("winslide"),
                this._pgView.lastPg()
            }
            ,
            t.prototype.nextClick = function() {
                l.default.playEffect("winslide"),
                this._pgView.nextPg(),
                this._pgView.isEnd() && (this._rightBtnNode.active = !1,
                this._leftBtnNode.active = !0)
            }
            ,
            t
        }(f);
        o.LeftRightDouble = _;
        var y = function() {
            function e() {}
            return e.prototype.check = function() {}
            ,
            e.prototype.setVisible = function() {}
            ,
            e
        }()
          , m = function(e) {
            function t(t, o, n, i, r) {
                var a = e.call(this) || this;
                a._toggles = [],
                a._pgView = r;
                for (var c = function(e) {
                    var n = cc.instantiate(t);
                    n.setParent(o),
                    f._toggles.push(n.getComponent(cc.Toggle)),
                    n.on("toggle", function() {
                        l.default.playEffect(s.ConstDefine.click),
                        a._pgView.toggleRoll(e),
                        a._pgView.btnControl.pageChange()
                    })
                }, f = this, h = n; h < i; h++)
                    c(h);
                return a
            }
            return i(t, e),
            t.prototype.check = function(e) {
                this._toggles[e].check()
            }
            ,
            t.prototype.setVisible = function(e, t) {
                this._toggles[e].node.active = t
            }
            ,
            t
        }(y)
          , v = function() {
            function e(e) {
                var t = this;
                if (this._playEffect = !0,
                this._lastPgIndex = 0,
                this._pgView = e.root.getComponent(cc.PageView),
                this._pgChangeCall = e.pgChangeCall,
                e.contents) {
                    var o = [];
                    o.push.apply(o, e.contents);
                    for (var n = 0; n < o.length; n++) {
                        var i = o[n];
                        i.setParent(null),
                        i.active = !0,
                        this._pgView.addPage(i)
                    }
                }
                switch (this.insertPage(e),
                this._contents = this._pgView.content.children,
                e.btnType) {
                case r.leftRightSeq:
                    this._btnControl = new d(this,e);
                    break;
                case r.rightShow:
                    this._btnControl = new g(this,e);
                    break;
                default:
                    this._btnControl = new f(this,e)
                }
                var a = e.toggleRoot || e.root.getChildByName("toggleRoot");
                a ? c.default.getResInfo(e.toggleName || s.ConstDefine.singleToggle).then(function(o) {
                    o || console.warn("\u6ca1\u6709\u8fd9\u6837\u7684toggle\u8d44\u6e90\u540d,\u662f\u4e0d\u662f\u914d\u7f6e\u9519\u8bef\u4e86", e.toggleName, s.ConstDefine.singleToggle),
                    t._toggle = new m(o.nodeInfo.root,a,t._toggleBeginIndex,t._pageCount,t),
                    c.default.hide(s.ConstDefine.singleToggle),
                    t.toggleCreateFinish(e)
                }) : (this._toggle = new y,
                this.toggleCreateFinish(e))
            }
            return Object.defineProperty(e.prototype, "pageCount", {
                get: function() {
                    return this._pageCount
                },
                enumerable: !1,
                configurable: !0
            }),
            Object.defineProperty(e.prototype, "pgView", {
                get: function() {
                    return this._pgView
                },
                enumerable: !1,
                configurable: !0
            }),
            Object.defineProperty(e.prototype, "contents", {
                get: function() {
                    return this._contents
                },
                enumerable: !1,
                configurable: !0
            }),
            Object.defineProperty(e.prototype, "btnControl", {
                get: function() {
                    return this._btnControl
                },
                enumerable: !1,
                configurable: !0
            }),
            e.prototype.resetPageCnt = function(e) {
                this._pageCount = e,
                this._pgView.getPages().length = e,
                this._pgView._calculateBoundary(),
                this._btnControl.resetPageCnt(e)
            }
            ,
            e.prototype.toggleCreateFinish = function(e) {
                e.root.on("scroll-ended", this.pgScrollEnded.bind(this)),
                this.toggleRoll(this._toggleBeginIndex, !1),
                e.finishCall && e.finishCall(this)
            }
            ,
            e.prototype.insertPage = function() {
                this._toggleBeginIndex = 0,
                this._pageCount = this._pgView.getPages().length
            }
            ,
            e.prototype.toggleRoll = function(e, t) {
                void 0 === t && (t = !0),
                this.toggleOn(e),
                this.pgScrollEnded(t)
            }
            ,
            e.prototype.toggleOn = function(e) {
                this._pgView.scrollToPage(e, 0)
            }
            ,
            e.prototype.pgScrollEnded = function(e) {
                void 0 === e && (e = !0);
                var t = this._pgView.getCurrentPageIndex();
                this._pgView.scrollToPage(t, 0),
                this._toggle.check(t);
                for (var o = 0; o < this._pageCount; ++o)
                    this._contents[o].opacity = o < t - 1 || o > t + 1 ? 0 : 255;
                this._btnControl.pageChange(),
                this._pgChangeCall && this._pgChangeCall(t, e)
            }
            ,
            e.prototype.setVisible = function(e, t) {
                this._toggle.setVisible(e, t),
                this._contents[e].active = t
            }
            ,
            e.prototype.nextPg = function() {
                var e = this._pgView.getCurrentPageIndex();
                e = ++e >= this._pageCount ? this._toggleBeginIndex : e,
                this._pgView.scrollToPage(e, void 0)
            }
            ,
            e.prototype.lastPg = function() {
                var e = this._pgView.getCurrentPageIndex();
                e = --e >= 0 ? e : this._pageCount - 1,
                this._pgView.scrollToPage(e, void 0)
            }
            ,
            e.prototype.clear = function() {
                for (var e = 0; e < this._contents.length; ++e)
                    this.setVisible(e, !1);
                this.resetPageCnt(0)
            }
            ,
            e.prototype.isEnd = function() {
                return this._pgView.getCurrentPageIndex() === this._pageCount - 1
            }
            ,
            e.prototype.isBegin = function() {
                return this._pgView.getCurrentPageIndex() === this._toggleBeginIndex
            }
            ,
            e.prototype.isScrolling = function() {
                return this.pgView.isScrolling() || this.pgView.isAutoScrolling()
            }
            ,
            e
        }();
        o.TogglePageView = v;
        var b = function(e) {
            function t() {
                return null !== e && e.apply(this, arguments) || this
            }
            return i(t, e),
            t.prototype.insertPage = function(e) {
                var t = this._pgView.content.childrenCount;
                if (t > 1) {
                    var o = this._pgView.content.children[0]
                      , n = this._pgView.content.children[t - 1];
                    this._pgView.insertPage(cc.instantiate(n), 0),
                    this._pgView.addPage(cc.instantiate(o)),
                    e.audoPlay && a.EffectMgr.Instance.trigger(a.EffectMgr.EffectType.EffectMeetCondition, 5, this.switchAd.bind(this), s.ConstDefine.emptyFunc)
                }
                this._toggleBeginIndex = 1,
                this._pageCount = this._pgView.getPages().length - 1
            }
            ,
            t.prototype.pgScrollEnded = function(e) {
                if (void 0 === e && (e = !0),
                !(this._pgView.content.childrenCount <= 1)) {
                    var t = this._pgView.getCurrentPageIndex();
                    t === this._pageCount ? (t = 1,
                    this.toggleOn(t)) : 0 === this._pgView.getCurrentPageIndex() && (t = this._pageCount - 1,
                    this.toggleOn(t)),
                    this._toggle.check(t - 1),
                    this._pgChangeCall && this._pgChangeCall(t - 1, e)
                }
            }
            ,
            t.prototype.switchAd = function() {
                var e = this._pgView.getCurrentPageIndex();
                return e = ++e > this._pageCount ? this._toggleBeginIndex : e,
                this._playEffect = !1,
                this._pgView.scrollToPage(e, void 0),
                !1
            }
            ,
            t
        }(v);
        o.LoopTogglePageView = b,
        cc._RF.pop()
    }
    , {
        "../../LogicMgr": "LogicMgr",
        "../../SoundMgr": "SoundMgr",
        "../../effect/EffectMgr": "EffectMgr",
        "../../res/DyncMgr": "DyncMgr"
    }],
    ParticlePlay: [function(e, t, o) {
        "use strict";
        cc._RF.push(t, "83dab9drO5Dm5Md+nTzB+33", "ParticlePlay");
        var n, i = this && this.__extends || (n = function(e, t) {
            return (n = Object.setPrototypeOf || {
                __proto__: []
            }instanceof Array && function(e, t) {
                e.__proto__ = t
            }
            || function(e, t) {
                for (var o in t)
                    Object.prototype.hasOwnProperty.call(t, o) && (e[o] = t[o])
            }
            )(e, t)
        }
        ,
        function(e, t) {
            function o() {
                this.constructor = e
            }
            n(e, t),
            e.prototype = null === t ? Object.create(t) : (o.prototype = t.prototype,
            new o)
        }
        );
        Object.defineProperty(o, "__esModule", {
            value: !0
        });
        var r = function(e) {
            function t() {
                return null !== e && e.apply(this, arguments) || this
            }
            return i(t, e),
            t.prototype.initParams = function() {
                e.prototype.initParams.call(this);
                var t = this._nodeInfo.root.getComponentsInChildren(cc.ParticleSystem3D);
                this._particle2Ds = this._nodeInfo.root.getComponentsInChildren(cc.ParticleSystem),
                this._playTime = 0;
                for (var o = 0, n = 0; n < this._particle2Ds.length; n++)
                    (o = this._particle2Ds[n].duration) > this._playTime && (this._playTime = o);
                for (n = 0; n < t.length; n++)
                    (o = this.getParTime(t[n])) > this._playTime && (this._playTime = o)
            }
            ,
            t.prototype.resetParams = function(t, o, n) {
                for (var i = this, r = [], a = 3; a < arguments.length; a++)
                    r[a - 3] = arguments[a];
                e.prototype.resetParams.apply(this, r),
                this._nodeInfo.root.setPosition(t),
                this._nodeInfo.root.scale = o || 1,
                this._nodeInfo.root.angle = n || 0;
                for (var s = 0, c = this._particle2Ds; s < c.length; s++) {
                    var l = c[s];
                    l.resetSystem()
                }
                setTimeout(function() {
                    i.hide()
                }, 1e3 * (this._playTime + .1))
            }
            ,
            t.prototype.hide = function() {
                e.prototype.hide.call(this);
                for (var t = 0, o = this._particle2Ds; t < o.length; t++)
                    o[t].stopSystem()
            }
            ,
            t.prototype.getParTime = function(e) {
                return e.duration + e.startLifetime.getMax() + e.startDelay.getMax()
            }
            ,
            t
        }(e("./DyncLoadedBase").default);
        o.default = r,
        cc._RF.pop()
    }
    , {
        "./DyncLoadedBase": "DyncLoadedBase"
    }],
    PcFullScreenUI: [function(e, t, o) {
        "use strict";
        cc._RF.push(t, "0f45fg0ZaZJIocJc0HwkU+E", "PcFullScreenUI");
        var n, i = this && this.__extends || (n = function(e, t) {
            return (n = Object.setPrototypeOf || {
                __proto__: []
            }instanceof Array && function(e, t) {
                e.__proto__ = t
            }
            || function(e, t) {
                for (var o in t)
                    Object.prototype.hasOwnProperty.call(t, o) && (e[o] = t[o])
            }
            )(e, t)
        }
        ,
        function(e, t) {
            function o() {
                this.constructor = e
            }
            n(e, t),
            e.prototype = null === t ? Object.create(t) : (o.prototype = t.prototype,
            new o)
        }
        );
        Object.defineProperty(o, "__esModule", {
            value: !0
        });
        var r = e("../../base/LogicMgr")
          , a = function(e) {
            function t() {
                return null !== e && e.apply(this, arguments) || this
            }
            return i(t, e),
            t.prototype.initParams = function() {
                this._fullScreen = this.nodeInfo.root.getChildByName("fullScreen"),
                this._fullScreen.on(r.ConstDefine.click, this.fullScreenClick, this),
                this._normal = this.nodeInfo.root.getChildByName("normal"),
                this._normal.on(r.ConstDefine.click, this.normalClick, this),
                this.visibleFullScreen(!this.isFull()),
                window.onresize = this.resize.bind(this)
            }
            ,
            t.prototype.fullScreenClick = function() {
                this.reqFullScreen(),
                this.visibleFullScreen(!1),
                this._manual = !0
            }
            ,
            t.prototype.normalClick = function() {
                this.exitFullScreen(),
                this.visibleFullScreen(!0),
                this._manual = !0
            }
            ,
            t.prototype.visibleFullScreen = function(e) {
                this._fullScreen.active = e,
                this._normal.active = !e
            }
            ,
            t.prototype.reqFullScreen = function() {
                if (window.top.reqFullScreen)
                    return window.top.reqFullScreen();
                var e = window.top.document.documentElement;
                e.requestFullscreen ? e.requestFullscreen() : e.webkitRequestFullScreen ? e.webkitRequestFullScreen() : e.mozRequestFullScreen ? e.mozRequestFullScreen() : e.msRequestFullscreen && e.msRequestFullscreen()
            }
            ,
            t.prototype.exitFullScreen = function() {
                if (window.top.exitFullScreen)
                    return window.top.exitFullScreen();
                var e = window.top.document;
                e.exitFullscreen ? e.exitFullscreen() : e.webkitCancelFullScreen ? e.webkitCancelFullScreen() : e.mozCancelFullScreen ? e.mozCancelFullScreen() : e.msExitFullscreen && e.msExitFullscreen()
            }
            ,
            t.prototype.isFullScreen = function() {
                if (window.top.isFullScreen)
                    return window.top.isFullScreen();
                var e = window.top.document;
                return e.fullScreen || e.mozFullScreen || e.webkitIsFullScreen || e.msFullscreenElement || !1
            }
            ,
            t.prototype.resize = function() {
                this._manual ? this._manual = !1 : this.visibleFullScreen(!this.isFull())
            }
            ,
            t.prototype.isFull = function() {
                return Math.abs(window.screen.height - window.document.documentElement.clientHeight) <= 17
            }
            ,
            t
        }(e("../../base/res/DyncLoadedBase").default);
        o.default = a,
        cc._RF.pop()
    }
    , {
        "../../base/LogicMgr": "LogicMgr",
        "../../base/res/DyncLoadedBase": "DyncLoadedBase"
    }],
    ReconnectTip: [function(e, t, o) {
        "use strict";
        cc._RF.push(t, "073eertZB5Ggr4u/B01v24l", "ReconnectTip");
        var n, i = this && this.__extends || (n = function(e, t) {
            return (n = Object.setPrototypeOf || {
                __proto__: []
            }instanceof Array && function(e, t) {
                e.__proto__ = t
            }
            || function(e, t) {
                for (var o in t)
                    Object.prototype.hasOwnProperty.call(t, o) && (e[o] = t[o])
            }
            )(e, t)
        }
        ,
        function(e, t) {
            function o() {
                this.constructor = e
            }
            n(e, t),
            e.prototype = null === t ? Object.create(t) : (o.prototype = t.prototype,
            new o)
        }
        );
        Object.defineProperty(o, "__esModule", {
            value: !0
        });
        var r = e("../../base/common/view/Tip")
          , a = e("../../base/LogicMgr")
          , s = e("../../base/net/NetMgr")
          , c = function(e) {
            function t() {
                return null !== e && e.apply(this, arguments) || this
            }
            return i(t, e),
            t.prototype.initParams = function() {
                e.prototype.initParams.call(this),
                this._popupMethod.root.getChildByName("cancel").on(a.ConstDefine.click, this.cancelClick, this)
            }
            ,
            t.prototype.cancelClick = function() {
                s.NetMgr.close()
            }
            ,
            t
        }(r.PopupBase);
        o.default = c,
        cc._RF.pop()
    }
    , {
        "../../base/LogicMgr": "LogicMgr",
        "../../base/common/view/Tip": "Tip",
        "../../base/net/NetMgr": "NetMgr"
    }],
    ResCfg: [function(e, t, o) {
        "use strict";
        cc._RF.push(t, "7dc6c2andxEaZkef50r/oc3", "ResCfg"),
        Object.defineProperty(o, "__esModule", {
            value: !0
        }),
        o.DyncInfoType = o.DyncLoadMode = o.ResType = o.DyncResMode = o.ResOpera = void 0,
        function(e) {
            e[e.NODE = 0] = "NODE",
            e[e.PROPERTY = 1] = "PROPERTY",
            e[e.RESSprite = 2] = "RESSprite",
            e[e.RESLabel = 3] = "RESLabel",
            e[e.Num = 4] = "Num"
        }(o.ResOpera || (o.ResOpera = {})),
        function(e) {
            e[e.Wait = 0] = "Wait",
            e[e.Once = 1] = "Once",
            e[e.Frequent = 2] = "Frequent",
            e[e.Controlled = 3] = "Controlled",
            e[e.Destroy = 4] = "Destroy"
        }(o.DyncResMode || (o.DyncResMode = {})),
        function(e) {
            e[e.Prefab = 0] = "Prefab",
            e[e.SpriteFrame = 1] = "SpriteFrame"
        }(o.ResType || (o.ResType = {})),
        function(e) {
            e[e.default = 0] = "default",
            e[e.language = 1] = "language"
        }(o.DyncLoadMode || (o.DyncLoadMode = {})),
        function(e) {
            e[e.asset = 0] = "asset",
            e[e.singleNode = 1] = "singleNode",
            e[e.mulNode = 2] = "mulNode"
        }(o.DyncInfoType || (o.DyncInfoType = {})),
        cc._RF.pop()
    }
    , {}],
    RollPrize: [function(e, t, o) {
        "use strict";
        cc._RF.push(t, "32b7ecUnJ1EB5I4ypd7PueQ", "RollPrize");
        var n, i = this && this.__extends || (n = function(e, t) {
            return (n = Object.setPrototypeOf || {
                __proto__: []
            }instanceof Array && function(e, t) {
                e.__proto__ = t
            }
            || function(e, t) {
                for (var o in t)
                    Object.prototype.hasOwnProperty.call(t, o) && (e[o] = t[o])
            }
            )(e, t)
        }
        ,
        function(e, t) {
            function o() {
                this.constructor = e
            }
            n(e, t),
            e.prototype = null === t ? Object.create(t) : (o.prototype = t.prototype,
            new o)
        }
        );
        Object.defineProperty(o, "__esModule", {
            value: !0
        });
        var r = e("../../base/common/MessageMgr")
          , a = e("../../base/common/SpecialFunc")
          , s = e("../config/Config")
          , c = e("../../base/net/EEvent")
          , l = e("../../base/SoundMgr")
          , f = e("../../base/common/view/Tip")
          , h = e("../../base/common/Func")
          , d = e("../../base/net/NetMgr")
          , u = e("../../base/LogicMgr")
          , p = e("../../base/res/DyncMgr")
          , g = e("../../base/res/LanguageMgr")
          , _ = u.default.v3Tmp
          , y = function(e) {
            function t() {
                var t = null !== e && e.apply(this, arguments) || this;
                return t._effectInfo = {
                    id: 0,
                    name: ""
                },
                t
            }
            return i(t, e),
            t.prototype.initParams = function() {
                var t = this;
                e.prototype.initParams.call(this);
                var o = this._popupMethod.root;
                this._bg2Node = o.getChildByName("bg2"),
                this._bg2AnimState = this._bg2Node.getComponent(cc.Animation).getAnimationState("bg2"),
                this._closeNode = o.getChildByName(u.ConstDefine.close),
                this._closeNode.on(u.ConstDefine.click, this.close, this),
                this._panNode = o.getChildByName("pan"),
                this._panNode.getScale(_),
                this._panScale = _.x,
                this._panAnim = this._panNode.getComponent(cc.Animation),
                this._centerNode = this._panNode.getChildByName("center");
                var n = this._centerNode.getChildByName("btnSpin");
                this._spinBtn = n.getComponent(cc.Button),
                n.on(u.ConstDefine.click, function() {
                    d.NetMgr.createWebSocket(),
                    t._spinBtn.enabled = !1,
                    l.default.playEffect("prize_2"),
                    r.MessageMgr.once(r.MessageName.NetOpen, t.netOpen, t)
                }),
                this._rotateWaiNode = this._centerNode.getChildByName("rotateWai"),
                this._rotateWaiAnim = this._rotateWaiNode.getComponent(cc.Animation),
                this._rotateNode = this._centerNode.getChildByName("rotate"),
                this._tipNode = this._rotateNode.getChildByName("tip");
                var i = this._rotateNode.getChildByName("prize")
                  , c = i.getChildByName("val");
                c.getChildByName(u.ConstDefine.text).getComponent(cc.Label).string = "GOOD LUCK";
                for (var f = s.Config.prize1.length; f < s.Config.prizeNum; ++f)
                    s.Config.prize1.push(0);
                for (this._perAngle = 360 / s.Config.prizeNum,
                f = 0; f < s.Config.prizeNum; ++f) {
                    var p = h.default.instanceMount(c, i);
                    p.angle = -this._perAngle * f;
                    var g = s.Config.prize1[f];
                    0 !== g && (p.getChildByName(u.ConstDefine.text).getComponent(cc.Label).string = a.default.convertDecimalNum(g))
                }
                c.destroy(),
                this._winTipNode = o.getChildByName("winTip");
                var y = this._winTipNode.getChildByName("frame_bonus tip");
                this._winText = y.getChildByName("text").getComponent(cc.Label);
                var m = y.getChildByName("btn");
                m.on(u.ConstDefine.click, this.getPrize, this),
                this._winBtn = m.getComponent(cc.Button),
                this._jinbiNode = this.nodeInfo.root.getChildByName("jinbi")
            }
            ,
            t.prototype.resetParams = function() {
                e.prototype.resetParams.call(this),
                this._rotateWaiAnim.enabled = !0,
                this._bg2Node.active = !1,
                this._spinBtn.enabled = !0,
                this._closeNode.active = !0,
                this._winTipNode.active = !1,
                this._winBtn.enabled = !0,
                this._jinbiNode.setPosition(u.ConstDefine.vec3ZERO);
                for (var t = 0, o = this._jinbiNode.children; t < o.length; t++)
                    o[t].setScale(0);
                this._tipNode.active = !1,
                this._rotateWaiNode.angle = 0,
                this._rotateNode.angle = 0,
                this._popupMethod.root.opacity = 255,
                this._panAnim.play(),
                r.MessageMgr.on(r.MessageName.NetMsg, this.onLogonNet, this),
                this._musicName = l.default.getCurBgName(),
                l.default.playBGM("prize_0", !0)
            }
            ,
            t.prototype.hide = function() {
                e.prototype.hide.call(this),
                l.default.playBGM(this._musicName),
                r.MessageMgr.off(r.MessageName.NetMsg, this.onLogonNet, this)
            }
            ,
            t.prototype.jinbiMove = function() {
                var e = this;
                l.default.playEffect("prize_8"),
                cc.tween(this._popupMethod.root).to(1.5, {
                    opacity: 0
                }).start();
                for (var t = 0, o = this._jinbiNode.children; t < o.length; t++) {
                    var n = o[t];
                    cc.tween(n).to(1, {
                        scale: 1.5
                    }).start()
                }
                var i = u.default.creditNode.parent.convertToWorldSpaceAR(u.default.creditNode.position);
                this._jinbiNode.parent.convertToNodeSpaceAR(i, _),
                cc.tween(this._jinbiNode).to(1.5, {
                    position: _
                }).call(function() {
                    u.default.reqUserInfo(),
                    e.hide()
                }).start()
            }
            ,
            t.prototype.getPrize = function() {
                l.default.playEffect("prize_2"),
                l.default.playEffect("prize_7"),
                this._winBtn.enabled = !1,
                this._jinbiNode.opacity = 255;
                for (var e = 0, t = this._jinbiNode.children; e < t.length; e++)
                    t[e].setScale(3);
                setTimeout(this.jinbiMove.bind(this), 2e3)
            }
            ,
            t.prototype.showWinTip = function() {
                l.default.playEffect("prize_5"),
                l.default.playEffect("prize_6"),
                this._winTipNode.active = !0,
                this._winText.string = a.default.convertDecimalNum(this._prizeVal),
                this._winTipNode.setScale(0),
                cc.tween(this._winTipNode).to(.3, {
                    scale: 1
                }).start()
            }
            ,
            t.prototype.rotateEnd = function() {
                var e = this;
                this._tipNode.active = !0,
                this._prizeVal > 0 ? setTimeout(this.showWinTip.bind(this), 1e3) : (u.default.reqUserInfo(),
                setTimeout(function() {
                    cc.tween(e._popupMethod.root).to(1.5, {
                        opacity: 0
                    }).call(e.hide, e).start()
                }, 3e3)),
                l.default.stopEffect(this._effectInfo.id, this._effectInfo.name),
                l.default.playEffect("prize_4")
            }
            ,
            t.prototype.netOpen = function() {
                var e = {
                    userid: u.default.login.userID,
                    dynamicpass: u.default.login.dynamicPass
                };
                d.NetMgr.send(c.Cmd.MDM_MB_LOGON, c.Cmd.SUB_MB_LOGON_CHOUJIANG, e)
            }
            ,
            t.prototype.onLogonNet = function(e) {
                var t = this;
                if (e.mainID === c.Cmd.MDM_MB_LOGON && e.subID === c.Cmd.SUB_MB_LOGON_CHOUJIANG_RESULT) {
                    var o = e.data;
                    if (0 != o.result)
                        return void ("" != o.msg && p.default.getResInfo(u.ConstDefine.msgTip, g.default.procBsText(o.msg), 5));
                    for (var n = -1e3, i = 0; i < s.Config.prizeNum; ++i)
                        s.Config.prize1[i] === o.lotteryscore && (this._prizeIndex = i,
                        n = s.Config.prize1[i]);
                    if (n < -999)
                        return void console.error("\u627e\u4e0d\u5230\u5408\u7406\u7684\u4e2d\u5956\u9879\u76ee!! ", o.lotteryscore);
                    this._prizeVal = n,
                    u.default.login.score = o.score,
                    l.default.playEffect("prize_3", this._effectInfo),
                    this._closeNode.active = !1,
                    cc.tween(this._panNode).to(.1, {
                        scale: 4
                    }).to(.3, {
                        scale: this._panScale
                    }).start(),
                    this._rotateWaiAnim.enabled = !1,
                    this._bg2Node.active = !0;
                    var r = this._prizeIndex * this._perAngle + 90;
                    this._tipNode.angle = -r,
                    r += 4320,
                    cc.tween(this._rotateNode).to(12, {
                        angle: r
                    }, {
                        easing: "cubicOut",
                        onUpdate: function(e, o) {
                            var n = .1;
                            e.angle > 0 && (n = e.angle / r / o),
                            t._bg2AnimState.speed = n
                        }
                    }).call(this.rotateEnd, this).start(),
                    cc.tween(this._rotateWaiNode).to(12, {
                        angle: -r
                    }, {
                        easing: "cubicOut"
                    }).start(),
                    d.NetMgr.close()
                }
            }
            ,
            t
        }(f.PopupBase);
        o.default = y,
        cc._RF.pop()
    }
    , {
        "../../base/LogicMgr": "LogicMgr",
        "../../base/SoundMgr": "SoundMgr",
        "../../base/common/Func": "Func",
        "../../base/common/MessageMgr": "MessageMgr",
        "../../base/common/SpecialFunc": "SpecialFunc",
        "../../base/common/view/Tip": "Tip",
        "../../base/net/EEvent": "EEvent",
        "../../base/net/NetMgr": "NetMgr",
        "../../base/res/DyncMgr": "DyncMgr",
        "../../base/res/LanguageMgr": "LanguageMgr",
        "../config/Config": "Config"
    }],
    SceneParticlesBatching: [function(e, t, o) {
        "use strict";
        cc._RF.push(t, "e6bcfPzBdJPSK3Tm1/cp0Ty", "SceneParticlesBatching");
        var n, i = this && this.__extends || (n = function(e, t) {
            return (n = Object.setPrototypeOf || {
                __proto__: []
            }instanceof Array && function(e, t) {
                e.__proto__ = t
            }
            || function(e, t) {
                for (var o in t)
                    Object.prototype.hasOwnProperty.call(t, o) && (e[o] = t[o])
            }
            )(e, t)
        }
        ,
        function(e, t) {
            function o() {
                this.constructor = e
            }
            n(e, t),
            e.prototype = null === t ? Object.create(t) : (o.prototype = t.prototype,
            new o)
        }
        ), r = this && this.__decorate || function(e, t, o, n) {
            var i, r = arguments.length, a = r < 3 ? t : null === n ? n = Object.getOwnPropertyDescriptor(t, o) : n;
            if ("object" == typeof Reflect && "function" == typeof Reflect.decorate)
                a = Reflect.decorate(e, t, o, n);
            else
                for (var s = e.length - 1; s >= 0; s--)
                    (i = e[s]) && (a = (r < 3 ? i(a) : r > 3 ? i(t, o, a) : i(t, o)) || a);
            return r > 3 && a && Object.defineProperty(t, o, a),
            a
        }
        ;
        Object.defineProperty(o, "__esModule", {
            value: !0
        });
        var a = cc._decorator
          , s = a.ccclass
          , c = (a.property,
        function(e) {
            function t() {
                var t = null !== e && e.apply(this, arguments) || this;
                return t._originFillBuffersFn = null,
                t
            }
            return i(t, e),
            t.prototype.onLoad = function() {}
            ,
            t.prototype.Batching = function() {
                if (!this._originFillBuffersFn) {
                    var e = cc.ParticleSystem.__assembler__;
                    this._originFillBuffersFn = e.prototype.fillBuffers,
                    e.prototype.fillBuffers = function(e, t) {
                        if (this._ia) {
                            var o = e._simulator.particles.length;
                            if (0 !== o) {
                                var n = cc.ParticleSystem.PositionType;
                                e.positionType === n.RELATIVE ? t.node = e.node.parent : t.node = e.node;
                                var i = this.getBuffer()
                                  , r = cc.renderer._handle._meshBuffer
                                  , a = r.request(4 * o, 6 * o)
                                  , s = a.byteOffset >> 2
                                  , c = r._vData
                                  , l = i._vData
                                  , f = i._iData
                                  , h = 20 * o;
                                h + s > c.length ? c.set(l.subarray(0, c.length - s), s) : c.set(l.subarray(0, h), s);
                                for (var d = r._iData, u = a.indiceOffset, p = a.vertexOffset, g = 6 * o, _ = 0; _ < g; _++)
                                    d[u++] = p + f[_]
                            }
                        }
                    }
                }
            }
            ,
            t.prototype.Recover = function() {
                this._originFillBuffersFn && (cc.ParticleSystem.__assembler__.prototype.fillBuffers = this._originFillBuffersFn,
                this._originFillBuffersFn = null)
            }
            ,
            t.prototype.onDisable = function() {
                this.Recover()
            }
            ,
            r([s], t)
        }(cc.Component));
        o.default = c,
        cc._RF.pop()
    }
    , {}],
    ScreenMgr: [function(e, t, o) {
        "use strict";
        cc._RF.push(t, "b431eQKy+lDsJ71rwWaKFza", "ScreenMgr");
        var n, i = this && this.__extends || (n = function(e, t) {
            return (n = Object.setPrototypeOf || {
                __proto__: []
            }instanceof Array && function(e, t) {
                e.__proto__ = t
            }
            || function(e, t) {
                for (var o in t)
                    Object.prototype.hasOwnProperty.call(t, o) && (e[o] = t[o])
            }
            )(e, t)
        }
        ,
        function(e, t) {
            function o() {
                this.constructor = e
            }
            n(e, t),
            e.prototype = null === t ? Object.create(t) : (o.prototype = t.prototype,
            new o)
        }
        ), r = this && this.__decorate || function(e, t, o, n) {
            var i, r = arguments.length, a = r < 3 ? t : null === n ? n = Object.getOwnPropertyDescriptor(t, o) : n;
            if ("object" == typeof Reflect && "function" == typeof Reflect.decorate)
                a = Reflect.decorate(e, t, o, n);
            else
                for (var s = e.length - 1; s >= 0; s--)
                    (i = e[s]) && (a = (r < 3 ? i(a) : r > 3 ? i(t, o, a) : i(t, o)) || a);
            return r > 3 && a && Object.defineProperty(t, o, a),
            a
        }
        ;
        Object.defineProperty(o, "__esModule", {
            value: !0
        }),
        o.ScaleNode = o.Direction = o.ScaleType = o.ScreenMode = void 0;
        var a, s, c, l = e("./common/MessageMgr"), f = e("../my/config/Config"), h = e("./res/DyncMgr"), d = e("./common/SpecialFunc"), u = e("./LogicMgr");
        (function(e) {
            e[e.fitScreen = 0] = "fitScreen",
            e[e.fullScreen = 1] = "fullScreen"
        }
        )(a = o.ScreenMode || (o.ScreenMode = {})),
        function(e) {
            e[e.ScaleBig = 0] = "ScaleBig",
            e[e.ScaleSmall = 1] = "ScaleSmall",
            e[e.UnScale = 2] = "UnScale"
        }(s = o.ScaleType || (o.ScaleType = {})),
        function(e) {
            e[e.DOWN = 0] = "DOWN",
            e[e.UP = 1] = "UP",
            e[e.LEFT = 2] = "LEFT",
            e[e.RIGHT = 3] = "RIGHT"
        }(c = o.Direction || (o.Direction = {}));
        var p = cc._decorator
          , g = p.ccclass
          , _ = p.executionOrder
          , y = function() {
            function e(e, t, o) {
                this.node = null,
                this.scaleType = s.UnScale,
                this.scaleMode = a.fitScreen,
                this.init(e, t, o)
            }
            return e.prototype.init = function(e, t, o) {
                this.node = e,
                this.scaleType = t,
                this.padDir = o,
                this.scaleMode = m.Instance.screenMode
            }
            ,
            e.prototype.setScaleMode = function(e, t) {
                if (this.scaleMode != t) {
                    switch (this.scaleType) {
                    case s.ScaleBig:
                        this.node.scaleX *= e.x,
                        this.node.scaleY *= e.y;
                        break;
                    case s.ScaleSmall:
                        this.node.scaleX *= 1 / e.x,
                        this.node.scaleY *= 1 / e.y
                    }
                    if (this.padDir)
                        for (var o = this.node.parent.convertToWorldSpaceAR(this.node.position), n = m.Instance.ca.convertToNodeSpaceAR(o), i = 0, r = this.padDir; i < r.length; i++) {
                            var a = void 0
                              , l = void 0;
                            switch (r[i]) {
                            case c.UP:
                                a = (f.Config.gameSize[1] / 2 - n.y) * (1 - 1 / e.y),
                                l = n.addSelf(new cc.Vec3(0,a,0));
                                break;
                            case c.DOWN:
                                a = (f.Config.gameSize[1] / 2 + n.y) * (1 - 1 / e.y),
                                l = n.subSelf(new cc.Vec3(0,a,0));
                                break;
                            case c.RIGHT:
                                a = (f.Config.gameSize[0] / 2 - n.x) * (1 - 1 / e.x),
                                l = n.addSelf(new cc.Vec3(a,0,0));
                                break;
                            case c.LEFT:
                                a = (f.Config.gameSize[0] / 2 + n.x) * (1 - 1 / e.x),
                                l = n.subSelf(new cc.Vec3(a,0,0))
                            }
                            var h = m.Instance.ca.convertToWorldSpaceAR(l);
                            this.node.setPosition(this.node.parent.convertToNodeSpaceAR(h))
                        }
                    this.scaleMode = t
                }
            }
            ,
            e
        }();
        o.ScaleNode = y;
        var m = function(e) {
            function t() {
                var t = null !== e && e.apply(this, arguments) || this;
                return t.nodes = [],
                t.variableID = 0,
                t.variableNode = [],
                t.screenMode = a.fitScreen,
                t.curScale = cc.Vec2.ONE,
                t
            }
            var o;
            return i(t, e),
            o = t,
            t.prototype.onLoad = function() {
                var e = this;
                this.ca = cc.find("Canvas"),
                o.Instance = this,
                l.MessageMgr.once(l.MessageName.LoadDyncResFinish, function() {
                    h.default.getResInfo("bounderyMask").then(function(t) {
                        t.nodeInfo.root.on(cc.Node.EventType.TOUCH_START, e.touchStart, e),
                        t.nodeInfo.root._touchListener.setSwallowTouches(!1),
                        t.nodeInfo.root.on(cc.Node.EventType.TOUCH_END, e.touchEnd, e)
                    })
                })
            }
            ,
            t.prototype.addNode = function(e, t) {
                if (d.default.isRotateDev())
                    if (e instanceof cc.Node) {
                        var o = new y(e,t);
                        this.nodes.push(o)
                    } else
                        this.nodes = this.nodes.concat(e)
            }
            ,
            t.prototype.addVariableNode = function(e) {
                if (d.default.isRotateDev()) {
                    for (var t = this.variableID, o = 0; o < e.length; o++)
                        this.variableNode.push({
                            id: this.variableID++,
                            node: e[o]
                        });
                    return [t, this.variableID - 1]
                }
            }
            ,
            t.prototype.decVariableNode = function(e) {
                var t = this;
                if (d.default.isRotateDev())
                    for (var o, n = function(e) {
                        i.variableNode.forEach(function(o, n) {
                            o.id == e && cc.js.array.fastRemoveAt(t.variableNode, n)
                        })
                    }, i = this, r = (o = "number" == typeof e ? [e, e] : e)[0]; r <= o[1]; r++)
                        n(r)
            }
            ,
            t.prototype.setScaleMode = function(e, t) {
                for (var o = 0; o < this.nodes.length; )
                    cc.isValid(this.nodes[o].node) ? (this.nodes[o].setScaleMode(e, t),
                    o++) : cc.js.array.fastRemoveAt(this.nodes, o);
                for (o = 0; o < this.variableNode.length; o++)
                    this.variableNode[o].node.setScaleMode(e, t);
                l.MessageMgr.emit(l.MessageName.SetScaleMode, e, t)
            }
            ,
            t.prototype.fitScreen = function() {
                d.default.isRotateDev() && (cc.view.setDesignResolutionSize(f.Config.gameSize[0], f.Config.gameSize[1], cc.ResolutionPolicy.SHOW_ALL),
                this.setScaleMode(new cc.Vec2(1 / this.curScale.x,1 / this.curScale.y), a.fitScreen),
                cc.Vec2.set(this.curScale, 1, 1),
                this.screenMode = a.fitScreen)
            }
            ,
            t.prototype.fullScreen = function() {
                if (d.default.isRotateDev()) {
                    cc.view.setDesignResolutionSize(f.Config.gameSize[0], f.Config.gameSize[1], cc.ResolutionPolicy.SHOW_ALL);
                    var e, t = cc.view.getFrameSize(), o = cc.view.getDesignResolutionSize(), n = t.width / t.height, i = o.width / o.height, r = 1, s = 1;
                    n > i ? ((e = cc.Size.ZERO).height = t.height,
                    e.width = e.height * i,
                    r = t.width / e.width) : ((e = cc.Size.ZERO).width = t.width,
                    e.height = e.width / i,
                    s = t.height / e.height),
                    cc.Vec2.set(this.curScale, r, s),
                    this.setScaleMode(this.curScale, a.fullScreen),
                    this.screenMode = a.fullScreen
                }
            }
            ,
            t.prototype.updateScreenMode = function(e) {
                e == a.fitScreen ? this.fitScreen() : this.fullScreen()
            }
            ,
            t.prototype.getScaleBig = function(e) {
                return new cc.Vec2(e.x * this.curScale.x,e.y * this.curScale.y)
            }
            ,
            t.prototype.getScaleSmall = function(e) {
                return new cc.Vec2(e.x / this.curScale.x,e.y / this.curScale.y)
            }
            ,
            t.prototype.touchStart = function(e) {
                h.default.isLoad("keyboardUI") || this.playClickAnim(e),
                l.MessageMgr.emit(l.MessageName.TouchStart, e)
            }
            ,
            t.prototype.touchEnd = function(e) {
                l.MessageMgr.emit(l.MessageName.TouchEnd, e)
            }
            ,
            t.prototype.playClickAnim = function(e) {
                var t = e.getLocation();
                h.default.getResInfo(u.ConstDefine.click, this.node.convertToNodeSpaceAR(t))
            }
            ,
            o = r([g, _(-5)], t)
        }(cc.Component);
        o.default = m,
        cc._RF.pop()
    }
    , {
        "../my/config/Config": "Config",
        "./LogicMgr": "LogicMgr",
        "./common/MessageMgr": "MessageMgr",
        "./common/SpecialFunc": "SpecialFunc",
        "./res/DyncMgr": "DyncMgr"
    }],
    ScrollPgView: [function(e, t, o) {
        "use strict";
        cc._RF.push(t, "9da35YdvlhMGrGke4seLdrt", "ScrollPgView");
        var n, i = this && this.__extends || (n = function(e, t) {
            return (n = Object.setPrototypeOf || {
                __proto__: []
            }instanceof Array && function(e, t) {
                e.__proto__ = t
            }
            || function(e, t) {
                for (var o in t)
                    Object.prototype.hasOwnProperty.call(t, o) && (e[o] = t[o])
            }
            )(e, t)
        }
        ,
        function(e, t) {
            function o() {
                this.constructor = e
            }
            n(e, t),
            e.prototype = null === t ? Object.create(t) : (o.prototype = t.prototype,
            new o)
        }
        ), r = this && this.__decorate || function(e, t, o, n) {
            var i, r = arguments.length, a = r < 3 ? t : null === n ? n = Object.getOwnPropertyDescriptor(t, o) : n;
            if ("object" == typeof Reflect && "function" == typeof Reflect.decorate)
                a = Reflect.decorate(e, t, o, n);
            else
                for (var s = e.length - 1; s >= 0; s--)
                    (i = e[s]) && (a = (r < 3 ? i(a) : r > 3 ? i(t, o, a) : i(t, o)) || a);
            return r > 3 && a && Object.defineProperty(t, o, a),
            a
        }
        ;
        Object.defineProperty(o, "__esModule", {
            value: !0
        });
        var a = cc._decorator
          , s = a.ccclass
          , c = (a.property,
        function(e) {
            function t() {
                return null !== e && e.apply(this, arguments) || this
            }
            return i(t, e),
            r([s], t)
        }(cc.PageView));
        o.default = c,
        cc._RF.pop()
    }
    , {}],
    SettingBox: [function(e, t, o) {
        "use strict";
        cc._RF.push(t, "70b0dE6/NJP9Lm+RWMN4xgF", "SettingBox");
        var n, i = this && this.__extends || (n = function(e, t) {
            return (n = Object.setPrototypeOf || {
                __proto__: []
            }instanceof Array && function(e, t) {
                e.__proto__ = t
            }
            || function(e, t) {
                for (var o in t)
                    Object.prototype.hasOwnProperty.call(t, o) && (e[o] = t[o])
            }
            )(e, t)
        }
        ,
        function(e, t) {
            function o() {
                this.constructor = e
            }
            n(e, t),
            e.prototype = null === t ? Object.create(t) : (o.prototype = t.prototype,
            new o)
        }
        );
        Object.defineProperty(o, "__esModule", {
            value: !0
        }),
        o.SettingBox = void 0;
        var r = e("../../base/SoundMgr")
          , a = e("../../base/common/view/SliderProgress")
          , s = e("../../base/common/view/Tip")
          , c = e("../../base/LogicMgr")
          , l = e("../../base/common/MessageMgr")
          , f = e("../../base/res/LanguageMgr")
          , h = function(e) {
            function t() {
                var t = null !== e && e.apply(this, arguments) || this;
                return t._langNode = [],
                t
            }
            return i(t, e),
            t.prototype.initParams = function() {
                var t = this;
                e.prototype.initParams.call(this),
                this.nodeInfo.root.getChildByName(c.ConstDefine.close).on(c.ConstDefine.click, this.close, this);
                var o = this._popupMethod.root.getChildByName("music");
                this._musicSP = new a.default(o,this.musicSlide.bind(this)),
                this._musicSP.setProgress(r.default.getBGMVol()),
                this._langNode.push(o.getChildByName("music"));
                var n = this._popupMethod.root.getChildByName("sound");
                this._soundSP = new a.default(n,this.soundSlide.bind(this)),
                this._soundSP.setProgress(r.default.getEffectVol()),
                this._langNode.push(n.getChildByName("sound"));
                var i = this._popupMethod.root.getChildByName("offsetX");
                this._langNode.push(i.getChildByName("title"));
                for (var s = cc.find("musicSelectFrame/btnGroup", i).children, f = function(e) {
                    var o = s[e];
                    h._langNode.push(o.getChildByName("Background")),
                    h._langNode.push(o.getChildByName("checkmark")),
                    o.on("toggle", function() {
                        t.musicClick(e)
                    })
                }, h = this, d = 0; d < s.length; d++)
                    f(d);
                var u = localStorage.getItem("hMS");
                if (u) {
                    var p = Number(u);
                    s[p].getComponent(cc.Toggle).check()
                } else
                    s[0].getComponent(cc.Toggle).check();
                l.MessageMgr.on(l.MessageName.ChangeLang, this.changeLang, this)
            }
            ,
            t.prototype.resetParams = function() {
                for (var t = [], o = 0; o < arguments.length; o++)
                    t[o] = arguments[o];
                e.prototype.resetParams.apply(this, t),
                this.changeLang()
            }
            ,
            t.prototype.hide = function() {
                l.MessageMgr.off(l.MessageName.ChangeLang, this.changeLang, this),
                e.prototype.hide.call(this)
            }
            ,
            t.prototype.changeLang = function() {
                f.default.procLangNodeArr(this._langNode)
            }
            ,
            t.prototype.musicClick = function(e) {
                r.default.playEffect(c.ConstDefine.click),
                e < 6 ? r.default.playBGM("bg" + e) : r.default.playBGM("bg"),
                localStorage.setItem("hMS", e.toString())
            }
            ,
            t.prototype.musicSlide = function(e) {
                r.default.setBGMVol(e)
            }
            ,
            t.prototype.soundSlide = function(e) {
                r.default.setEffectVol(e)
            }
            ,
            t
        }(s.PopupBase);
        o.SettingBox = h,
        cc._RF.pop()
    }
    , {
        "../../base/LogicMgr": "LogicMgr",
        "../../base/SoundMgr": "SoundMgr",
        "../../base/common/MessageMgr": "MessageMgr",
        "../../base/common/view/SliderProgress": "SliderProgress",
        "../../base/common/view/Tip": "Tip",
        "../../base/res/LanguageMgr": "LanguageMgr"
    }],
    ShareUI: [function(e, t, o) {
        "use strict";
        cc._RF.push(t, "70ea6vl1EJPqrK8ZJiY7oRj", "ShareUI");
        var n, i = this && this.__extends || (n = function(e, t) {
            return (n = Object.setPrototypeOf || {
                __proto__: []
            }instanceof Array && function(e, t) {
                e.__proto__ = t
            }
            || function(e, t) {
                for (var o in t)
                    Object.prototype.hasOwnProperty.call(t, o) && (e[o] = t[o])
            }
            )(e, t)
        }
        ,
        function(e, t) {
            function o() {
                this.constructor = e
            }
            n(e, t),
            e.prototype = null === t ? Object.create(t) : (o.prototype = t.prototype,
            new o)
        }
        );
        Object.defineProperty(o, "__esModule", {
            value: !0
        }),
        o.ShareUI = void 0;
        var r = e("../../base/common/view/Tip")
          , a = e("../../base/LogicMgr")
          , s = e("../config/Config")
          , c = function(e) {
            function t() {
                return null !== e && e.apply(this, arguments) || this
            }
            return i(t, e),
            t.prototype.initParams = function() {
                e.prototype.initParams.call(this),
                this._popupMethod.root.getChildByName(a.ConstDefine.close).on(a.ConstDefine.click, this.close, this);
                var t = this._popupMethod.root.getChildByName("qrCode");
                cc.assetManager.loadRemote(s.Config.configPath + "qrCode.png", function(e, o) {
                    e || (t.getComponent(cc.Sprite).spriteFrame = new cc.SpriteFrame(o))
                })
            }
            ,
            t
        }(r.PopupBase);
        o.ShareUI = c,
        cc._RF.pop()
    }
    , {
        "../../base/LogicMgr": "LogicMgr",
        "../../base/common/view/Tip": "Tip",
        "../config/Config": "Config"
    }],
    SliderProgress: [function(e, t, o) {
        "use strict";
        cc._RF.push(t, "83136jFLk5G7LNVyaf2uStd", "SliderProgress"),
        Object.defineProperty(o, "__esModule", {
            value: !0
        });
        var n = function() {
            function e(e, t) {
                var o = this;
                this._slider = e.getComponent(cc.Slider),
                this._barSptframe = e.getChildByName("progressBar").getChildByName("bar").getComponent(cc.Sprite),
                this._slider.node.on("slide", function() {
                    o._barSptframe.fillRange = o._slider.progress,
                    t(o._slider.progress)
                }, this)
            }
            return e.prototype.setProgress = function(e) {
                this._slider.progress = e,
                this._barSptframe.fillRange = this._slider.progress
            }
            ,
            e
        }();
        o.default = n,
        cc._RF.pop()
    }
    , {}],
    SoundMgr: [function(e, t, o) {
        "use strict";
        cc._RF.push(t, "28020NzcKtAY7FrNSg0qhP2", "SoundMgr"),
        Object.defineProperty(o, "__esModule", {
            value: !0
        });
        var n, i, r = e("./common/Func"), a = e("./common/MessageMgr"), s = e("../my/config/Config"), c = e("./effect/EffectMgr"), l = e("./res/DyncMgr"), f = e("./res/LanguageMgr"), h = e("./LogicMgr"), d = "bg", u = null, p = null, g = 1, _ = 1, y = !0, m = !1, v = !1, b = function() {
            function e() {}
            return e.enabled = function() {
                return y
            }
            ,
            e.loadClip = function(e) {
                return new Promise(function(t) {
                    e.asset ? t(e.asset) : l.default.bundles[e.loadIndex].load(e.path, cc.AudioClip, function(o, n) {
                        o ? (console.error("\u52a0\u8f7d\u97f3\u6548\u51fa\u9519", e.path, o),
                        t(null)) : (e.asset = n,
                        e.duration = Math.floor(n.duration),
                        t(n))
                    })
                }
                )
            }
            ,
            e.removeIdByCfg = function(e, t) {
                var o = cc.audioEngine.getState(t);
                (o > cc.audioEngine.AudioState.PLAYING || o < cc.audioEngine.AudioState.INITIALZING) && cc.audioEngine.stopEffect(t),
                cc.js.array.fastRemove(e.ids, t),
                e.ids.length <= 0 && this.releaseAsset(e)
            }
            ,
            e.init = function() {
                var e = this;
                cc.resources.load("json/soundCfg", cc.JsonAsset, function(t, o) {
                    if (t)
                        cc.error(t.message || t);
                    else {
                        i = o.json,
                        "shengdan" == s.Config.theme && (i.bg0 = i.shengdan,
                        i.bg[0] = Object.assign({}, i.shengdan[0]),
                        delete i.shengdan);
                        var r = s.Config.soundCfg;
                        n = r.load,
                        s.Config.soundCfg = null,
                        function(e) {
                            for (var t in e)
                                for (var o = 0, n = e[t]; o < n.length; o++)
                                    c(n[o], "sound/")
                        }(i),
                        localStorage.getItem("hMO") && (m = !0),
                        localStorage.getItem("hEO") && (v = !0),
                        m || e.beginPlayMusic();
                        var a = localStorage.getItem("hSV");
                        a ? e.setEffectVol(Number(a)) : e.setEffectVol(_)
                    }
                    function c(e, t) {
                        var o = [];
                        if (e.lst && e.lst.length > 0) {
                            for (var i = [], r = e.lst[0]; r <= e.lst[1]; r++)
                                i.push(e.name + String(r).padStart(3, "0"));
                            e.lst = i,
                            o = e.lst,
                            e.name = o[0]
                        } else
                            e.lst = [e.name],
                            o.push(e.name);
                        for (var a = 0, s = o; a < s.length; a++) {
                            var c = s[a];
                            n[c] || (n[c] = {
                                loadIndex: 0
                            },
                            n[c].path = t + c,
                            n[c].latPlayTime = 0,
                            n[c].timeOutIndex = 0,
                            n[c].ids = [])
                        }
                    }
                })
            }
            ,
            e.beginPlayMusic = function() {
                var e = localStorage.getItem(h.ConstDefine.musicName);
                e ? this.playBGM(e, !0) : this.playBGM(d, !0);
                var t = localStorage.getItem("hMV");
                t ? this.setBGMVol(Number(t)) : this.setBGMVol(g)
            }
            ,
            e.getSoundCfgByName = function(e) {
                var t = i[e];
                if (t)
                    return t[r.default.randomInt(0, t.length - 1)]
            }
            ,
            e.playBGM = function(e, t) {
                void 0 === t && (t = !1),
                m || (t || (d = e,
                localStorage.setItem(h.ConstDefine.musicName, e)),
                this.playBGMByCfg(this.getSoundCfgByName(e)))
            }
            ,
            e.stopBGM = function(e) {
                void 0 === e && (e = null),
                m || null != e && e.playing && (e.playing = !1,
                null == e.curMusicId ? this.releaseBgmAssest(e) : this.fadeBgm(e, 1, cc.audioEngine.getVolume(p.curMusicId), 0))
            }
            ,
            e.playMultiBgm = function(e, t, o) {
                var i = this;
                void 0 === o && (o = !1);
                var r = e.lst.length
                  , a = e.lst[t]
                  , s = n[a];
                if (o)
                    this.lastPlayTime = Date.now() / 1e3,
                    this.stopBGM(u),
                    e.curMusicId = cc.audioEngine.play(s.asset, !1, 0),
                    this.fadeBgm(e, 1, 0, e.vol * g),
                    e.playTime = performance.now();
                else {
                    var l = cc.audioEngine.getVolume(e.curMusicId);
                    cc.audioEngine.stopEffect(e.curMusicId),
                    e.curMusicId = cc.audioEngine.play(s.asset, !1, l)
                }
                var f = (t + 1) % r;
                if (!(f <= t) || e.loop) {
                    var d = 0
                      , p = -1
                      , _ = s.duration;
                    e.timer = c.EffectMgr.Instance.trigger(c.EffectMgr.EffectType.EffectMeetCondition, .01, function() {
                        if (!e.pause) {
                            if ((d += .01) < _)
                                return p < -.01 && d > _ - .1 && cc.audioEngine.getState(e.curMusicId) == cc.audioEngine.AudioState.PLAYING && (p = cc.audioEngine.getVolume(e.curMusicId)),
                                !1;
                            var o = Date.now() / 1e3;
                            return i.lastPlayTime = o,
                            d = 0,
                            f <= (t = (t + 1) % r) && !e.loop ? (null != e.timer && (e.timer.forceStop(),
                            e.timer = null),
                            !1) : (s = n[e.lst[t]],
                            _ = s.duration,
                            cc.audioEngine.stopEffect(e.curMusicId),
                            e.curMusicId = cc.audioEngine.play(s.asset, !1, p),
                            p = -1,
                            !1)
                        }
                    }, h.ConstDefine.emptyFunc)
                }
            }
            ,
            e.loadBgmClip = function(e, t) {
                var o = this;
                if (!m) {
                    var i = e.lst[t]
                      , r = n[i];
                    this.loadClip(r).then(function(n) {
                        if (e.playing && !m) {
                            if (null !== n) {
                                var i = e.lst.length;
                                if (i > 1) {
                                    if (!(t >= i - 1)) {
                                        0 == t && (u = p,
                                        p = e,
                                        o.playMultiBgm(e, 0, !0));
                                        var a = (t + 1) % i;
                                        return void o.loadBgmClip(e, a)
                                    }
                                } else
                                    u = p,
                                    p = e,
                                    o.stopBGM(u),
                                    e.curMusicId = cc.audioEngine.play(r.asset, e.loop, 0),
                                    o.fadeBgm(e, 1, 0, e.vol * g)
                            }
                        } else
                            o.releaseBgmAssest(e)
                    })
                }
            }
            ,
            e.playBGMByCfg = function(e) {
                m || null != p && p.name == e.name || (e.playing = !0,
                this.loadBgmClip(e, 0))
            }
            ,
            e.getCurBgName = function() {
                return d
            }
            ,
            e.stopEffect = function(e, t) {
                var o = n[t];
                o && (cc.audioEngine.stopEffect(e),
                !o.norecycle && this.removeIdByCfg(o, e))
            }
            ,
            e.stopAll = function() {
                for (var e in p && (this.stopBGM(p),
                p = null),
                cc.audioEngine.stopAllEffects(),
                n) {
                    var t = n[e];
                    t.ids.length = 0,
                    this.releaseAsset(t)
                }
            }
            ,
            e.releaseAsset = function(e) {
                e.norecycle || (cc.assetManager.releaseAsset(e.asset),
                e.asset = null)
            }
            ,
            e.pauseBGM = function() {
                m || (cc.audioEngine.pauseEffect(p.curMusicId),
                p.pause = !0)
            }
            ,
            e.resumeBGM = function() {
                m || (p.pause = !1,
                cc.audioEngine.resume(p.curMusicId))
            }
            ,
            e.setVol = function(e, t) {
                this.setBGMVol(e),
                this.setEffectVol(t),
                y = 0 === e && 0 === t
            }
            ,
            e.setBGMVol = function(e) {
                if (g = e,
                localStorage.setItem("hMV", e.toString()),
                null !== p && null != p.curMusicId) {
                    var t = g * p.vol;
                    cc.audioEngine.setVolume(p.curMusicId, t)
                }
            }
            ,
            e.getBGMVol = function(e) {
                return void 0 === e && (e = !0),
                g
            }
            ,
            e.offMusic = function(e) {
                m = e,
                e ? (localStorage.setItem("hMO", "1"),
                null !== p && null != p.curMusicId && cc.audioEngine.setVolume(p.curMusicId, 0)) : (localStorage.removeItem("hMO"),
                null !== p && null != p.curMusicId ? cc.audioEngine.setVolume(p.curMusicId, 1) : this.beginPlayMusic())
            }
            ,
            e.getOffMusice = function() {
                return m
            }
            ,
            e.offEffect = function(e) {
                v = e,
                e ? localStorage.setItem("hEO", "1") : localStorage.removeItem("hEO")
            }
            ,
            e.getOffEffect = function() {
                return v
            }
            ,
            e.setEffectVol = function(e) {
                _ = e,
                localStorage.setItem("hSV", e.toString())
            }
            ,
            e.getEffectVol = function() {
                return _
            }
            ,
            e.playEffect = function(e, t) {
                var o = this;
                if (!v) {
                    var i = this.getSoundCfgByName(e);
                    if (void 0 !== i) {
                        var r = n[i.name];
                        if (null == r)
                            return -2;
                        var a = performance.now();
                        r.latPlayTime < a && (r.latPlayTime = a + i.repeatInterval,
                        this.loadClip(r).then(function(e) {
                            null !== e && (i.delayTime ? c.EffectMgr.Instance.trigger(c.EffectMgr.EffectType.EffectMeetCondition, i.delayTime, h.ConstDefine.trueFunc, function() {
                                o.playAsset(r, i, t)
                            }) : o.playAsset(r, i, t))
                        }))
                    }
                }
            }
            ,
            e.playAsset = function(e, t, o) {
                var n = this
                  , i = cc.audioEngine.play(e.asset, t.loop, t.vol * _);
                t.playTime > 0 && (clearTimeout(e.timeOutIndex),
                e.timeOutIndex = setTimeout(function() {
                    n.removeIdByCfg(e, i)
                }, 1e3 * t.playTime)),
                e.norecycle || (e.ids.push(i),
                !t.loop && t.playTime <= 0 && cc.audioEngine.setFinishCallback(i, function() {
                    n.removeIdByCfg(e, i)
                })),
                o && (o.id = i,
                o.name = t.name)
            }
            ,
            e.releaseBgmAssest = function(e) {
                for (var t = 0, o = e.lst; t < o.length; t++) {
                    var i = o[t]
                      , r = n[i];
                    r && r.asset && this.releaseAsset(r)
                }
                null != e.timer && (e.timer.forceStop(),
                e.timer = null),
                e.curMusicId = null
            }
            ,
            e.fadeBgm = function(e, t, o, n) {
                var i = this;
                if (o !== n) {
                    var r = t / .05 * (n - o)
                      , a = n > o;
                    c.EffectMgr.Instance.trigger(c.EffectMgr.EffectType.EffectMeetCondition, .05, function() {
                        if (o += r,
                        a) {
                            if (!(o < n))
                                return cc.audioEngine.setVolume(e.curMusicId, n),
                                !0;
                            cc.audioEngine.setVolume(e.curMusicId, o)
                        } else {
                            if (!(o > n))
                                return cc.audioEngine.stopEffect(e.curMusicId),
                                i.releaseBgmAssest(e),
                                !0;
                            cc.audioEngine.setVolume(e.curMusicId, o)
                        }
                        return !1
                    }, h.ConstDefine.emptyFunc)
                }
            }
            ,
            e.lastPlayTime = 0,
            e
        }();
        o.default = b,
        a.MessageMgr.once(a.MessageName.LoadDyncResFinish, b.init, b),
        a.MessageMgr.on(a.MessageName.ChangeLang, function() {
            r.default.mergeJSON(i[f.default.currLang], i)
        }),
        cc._RF.pop()
    }
    , {
        "../my/config/Config": "Config",
        "./LogicMgr": "LogicMgr",
        "./common/Func": "Func",
        "./common/MessageMgr": "MessageMgr",
        "./effect/EffectMgr": "EffectMgr",
        "./res/DyncMgr": "DyncMgr",
        "./res/LanguageMgr": "LanguageMgr"
    }],
    SpecialFunc: [function(e, t, o) {
        "use strict";
        cc._RF.push(t, "965b9RLdetJVoxgj/5uZ33Z", "SpecialFunc"),
        Object.defineProperty(o, "__esModule", {
            value: !0
        });
        var n = e("../../my/config/Config")
          , i = e("../LogicMgr")
          , r = e("../res/DyncMgr")
          , a = e("../res/LanguageMgr")
          , s = function() {
            function e() {}
            return e.convertDecimalNum = function(e, t) {
                return 1 === (t = "number" == typeof t ? t : n.Config.decimalPlaces) && e % 10 != 0 && e >= 5 && (e -= 5),
                (e /= n.Config.decimal).toFixed(t)
            }
            ,
            e.converSepValue = function(t, o) {
                for (var n = e.convertDecimalNum(t, o); /\d{4}(\.|,)/.test(n); )
                    n = n.replace(/(\d)(\d{3}(\.|,))/, "$1,$2");
                return n
            }
            ,
            e.setLangSptArr = function(e, t, o) {
                for (var n, i = 0; i < t.length; i++) {
                    var r = t[i];
                    r.spriteFrame && r.spriteFrame.decRef(),
                    n = r.node.name,
                    o && (n = o + "/" + n),
                    this.setLangSpt(e, n, r)
                }
            }
            ,
            e.setLangSpt = function(e, t, o) {
                r.default.bundles[e].load("lang/" + a.default.currLang + "/" + t, cc.SpriteFrame, function(n, i) {
                    n ? r.default.bundles[e].load("lang/" + a.default.defaultLang + "/" + t, cc.SpriteFrame, function(e, t) {
                        e || (t.addRef(),
                        o.spriteFrame = t)
                    }) : (i.addRef(),
                    o.spriteFrame = i)
                })
            }
            ,
            e.loadRemoteSpt = function(e, t, o, i) {
                void 0 === i && (i = void 0),
                e += o + (n.Config[t + o] || "") + ".png",
                cc.assetManager.loadRemote(e, i)
            }
            ,
            e.setRemoteSpt = function(e, t, o, n, i) {
                void 0 === i && (i = void 0),
                this.loadRemoteSpt(e, t, o, function(t, o) {
                    t ? cc.warn("\u52a0\u8f7d\u8fdc\u7a0b\u56fe\u7247\u51fa\u9519" + e) : n.spriteFrame = new cc.SpriteFrame(o),
                    i && i(t)
                })
            }
            ,
            e.setDyncSpt = function(e, t, o, n) {
                r.default.bundles[e].load(t, cc.SpriteFrame, function(e, i) {
                    e ? cc.error("\u52a0\u8f7d\u52a8\u6001\u7cbe\u7075\u5931\u8d25", t) : o.spriteFrame = i,
                    n && n(!e)
                })
            }
            ,
            e.getLangDir = function(e, t, o, n) {
                r.default.bundles[e].getDirWithPath("lang/" + a.default.currLang + "/" + t, o, n),
                0 === n.lenght && r.default.bundles[e].getDirWithPath("lang/" + a.default.defaultLang + "/" + t, o, n)
            }
            ,
            e.editInput = function(e, t) {
                if (i.default.useSoftKeyboard) {
                    var o = e.getComponent(cc.EditBox);
                    e.getComponent(cc.EditBox).onDestroy(),
                    o._impl = null,
                    e.on(cc.Node.EventType.TOUCH_END, function(o) {
                        r.default.getResInfo("keyboardUI", e, t),
                        o.stopPropagation()
                    })
                }
            }
            ,
            e.setSecEdit = function(e) {
                e._impl
            }
            ,
            e.isRotateDev = function() {
                return void 0 !== window.orientation
            }
            ,
            e.onMouseWheel = function(e, t) {
                t.isScrolling() || (e > 0 ? t.lastPg() : t.nextPg())
            }
            ,
            e.copyToClipboard = function(e, t) {
                if (null == e || e.length < 1)
                    return t(!1),
                    !1;
                if (navigator.clipboard)
                    return console.log("copyToClipboard navigator 1"),
                    navigator.clipboard.writeText(e).then(function() {
                        t(!0)
                    }).catch(function() {
                        t(!1)
                    }),
                    console.log("copyToClipboard navigator 2"),
                    !0;
                if (window.copyToClipBoard) {
                    var o = window.copyToClipBoard(e);
                    if (o)
                        return t(o),
                        !0
                }
                window.openCopyUi ? window.openCopyUi(e, null, function(e) {
                    t(e)
                }) : t(!1)
            }
            ,
            e.pasteFormCliboard = function(e, t) {
                if (!window.pasteFromClipBoard || !window.pasteFromClipBoard(function(o) {
                    null != o && "" != o.trim() ? (e.string = o,
                    t(!0)) : t(!1)
                }))
                    if (window.showNativeEditBox) {
                        var o = cc.sys.isMobile ? a.default.procLangText("pressPaste") : a.default.procLangText("paste");
                        window.showNativeEditBox("", o, function(o) {
                            null != o && "" != o.trim() ? (e.string = o,
                            t(!0)) : t(!1)
                        })
                    } else
                        t(!1)
            }
            ,
            e.reqFullScreen = function() {
                if (window.top.reqFullScreen)
                    return window.top.reqFullScreen();
                var e = window.top.document.documentElement;
                e.requestFullscreen ? e.requestFullscreen() : e.webkitRequestFullScreen ? e.webkitRequestFullScreen() : e.mozRequestFullScreen ? e.mozRequestFullScreen() : e.msRequestFullscreen && e.msRequestFullscreen()
            }
            ,
            e
        }();
        o.default = s,
        cc._RF.pop()
    }
    , {
        "../../my/config/Config": "Config",
        "../LogicMgr": "LogicMgr",
        "../res/DyncMgr": "DyncMgr",
        "../res/LanguageMgr": "LanguageMgr"
    }],
    TextDesc: [function(e, t, o) {
        "use strict";
        cc._RF.push(t, "04b08CNj9pP96XODiJV6tVF", "TextDesc"),
        Object.defineProperty(o, "__esModule", {
            value: !0
        }),
        o.LangText = void 0;
        var n = e("../../my/config/MutabTextDesc")
          , i = e("../common/Func")
          , r = e("../common/MessageMgr")
          , a = e("../../my/config/Config");
        o.LangText = {
            ch: {
                forgetTip: "\u8bf7\u8054\u7cfb\u60a8\u7684\u5ba2\u6237\u4e13\u5458\u627e\u56de\u5bc6\u7801.",
                changePwdTip: "\u65b0\u5bc6\u7801\u9700\u8981\u4fee\u6539",
                username: "\u7528\u6237\u540d",
                password: "\u5bc6\u7801",
                login: "\u767b\u5f55",
                loginTip: "\u7528\u6237\u540d\u6216\u5bc6\u7801\u9519\u8bef",
                homepage: "\u9996\u9875",
                games: "\u6e38\u620f",
                download: "\u4e0b\u8f7d",
                aboutUs: "\u5173\u4e8e",
                all_games: "\u5168\u90e8",
                fishing_games: "\u9c7c\u673a",
                slot_games: "\u8f6e\u7ebf"
            },
            en: {
                forgetTip: "Please contact the customer service to retrieve the password",
                commingTip: "The game is coming online, Please look forward to it\uff01",
                enterGameError: "No table",
                pwdFormatTip: "New password must include one letter and one number.",
                badNetStatus: "The server is busy, Please try again later.",
                exitLogin: "Exit the login?",
                changePwdTip: "Please change your password at first login.",
                username: "user name:",
                password: "password:",
                login: "login",
                loginTip: "Wrong user name or password",
                all_games: "ALL",
                new: "NEW",
                fishing_games: "FISHING",
                slot_games: "SLOT",
                others: "OTHERS",
                favorite: "FAVORITE",
                grand: "Grand",
                major: "Major",
                minor: "Minor",
                mini: "Mini",
                getPrize: "I get %s prize with %s at %s",
                cancle: "cancle",
                sure: "ok",
                inputAccoutTip: "Please Input Account",
                inputPwdTip: "Please Input Password",
                accountEmptyTip: "User name cannot be empty!",
                pwdEmptyTip: "Password cannot be empty!",
                pwdNotEmptyTip: "The password cannot be empty!!!",
                lengthTip: "The length of the account or password should be 6-32 bits",
                pwdLengthTip: "The length of password should be 6-32 bits",
                errorTip: "ERROR",
                notRunning: "The current game is not running",
                searchTip: "Find a game",
                pwdunlikeTip: "The two passwords you entered were inconsistent.",
                noSameTip: "New password should be different from old one",
                noFavTip: "You didn't pick any game into the favourite list.",
                maintenanceTip: "The game is under maintenance. Please try again later.",
                replayAvailable: "Video replay is not available now."
            }
        },
        r.MessageMgr.once(r.MessageName.LoadDyncResFinish, function() {
            i.default.coverCfgFunc(o.LangText, n.MutabLangText, a.Config.langText)
        }),
        cc._RF.pop()
    }
    , {
        "../../my/config/Config": "Config",
        "../../my/config/MutabTextDesc": "MutabTextDesc",
        "../common/Func": "Func",
        "../common/MessageMgr": "MessageMgr"
    }],
    TimeOutInterval: [function(e, t, o) {
        "use strict";
        cc._RF.push(t, "a7ae3zj5l9P0ImZcZlnlumM", "TimeOutInterval"),
        Object.defineProperty(o, "__esModule", {
            value: !0
        }),
        o.XFTimeOut = void 0;
        var n = function() {
            function e(e, t) {
                this._tim = null,
                this._func = e,
                this._timeOut = t
            }
            return e.prototype.start = function() {
                setTimeout(this._func, this._timeOut)
            }
            ,
            e.prototype.clear = function() {
                this._tim && (clearTimeout(this._tim),
                this._tim = null)
            }
            ,
            e
        }();
        o.XFTimeOut = n,
        cc._RF.pop()
    }
    , {}],
    Tip: [function(e, t, o) {
        "use strict";
        cc._RF.push(t, "e19cdQK00dDXKulY9wV7fX3", "Tip");
        var n, i = this && this.__extends || (n = function(e, t) {
            return (n = Object.setPrototypeOf || {
                __proto__: []
            }instanceof Array && function(e, t) {
                e.__proto__ = t
            }
            || function(e, t) {
                for (var o in t)
                    Object.prototype.hasOwnProperty.call(t, o) && (e[o] = t[o])
            }
            )(e, t)
        }
        ,
        function(e, t) {
            function o() {
                this.constructor = e
            }
            n(e, t),
            e.prototype = null === t ? Object.create(t) : (o.prototype = t.prototype,
            new o)
        }
        );
        Object.defineProperty(o, "__esModule", {
            value: !0
        }),
        o.PopupBase = o.PopupMethod = o.AutoHideTip = o.AutoHideTextTip = o.TextTip = void 0;
        var r = e("../../common/Func")
          , a = e("../../LogicMgr")
          , s = e("../../res/DyncLoadedBase")
          , c = function(e) {
            function t() {
                return null !== e && e.apply(this, arguments) || this
            }
            return i(t, e),
            t.prototype.initParams = function() {
                this._textTip = this.nodeInfo.root.getChildByName("tip").getComponent(cc.Label)
            }
            ,
            t.prototype.resetParams = function(e) {
                for (var t = [], o = 1; o < arguments.length; o++)
                    t[o - 1] = arguments[o];
                this._textTip.string = e
            }
            ,
            t
        }(s.default);
        o.TextTip = c;
        var l = function(e) {
            function t() {
                return null !== e && e.apply(this, arguments) || this
            }
            return i(t, e),
            t.prototype.initParams = function() {
                var t = this;
                e.prototype.initParams.call(this),
                this._mask = this.nodeInfo.root.getChildByName("mask"),
                this._mask.on(a.ConstDefine.click, function() {
                    clearTimeout(t._timeHandle),
                    t.hide()
                })
            }
            ,
            t.prototype.resetParams = function(t, o, n) {
                var i = this;
                void 0 === o && (o = 2),
                void 0 === n && (n = !0);
                for (var r = [], a = 3; a < arguments.length; a++)
                    r[a - 3] = arguments[a];
                e.prototype.resetParams.call(this, t),
                this._mask.active = n,
                clearTimeout(this._timeHandle),
                this._timeHandle = setTimeout(function() {
                    i.hide()
                }, 1e3 * o)
            }
            ,
            t.prototype.isReset = function() {
                return !0
            }
            ,
            t
        }(c);
        o.AutoHideTextTip = l;
        var f = function(e) {
            function t() {
                var t = null !== e && e.apply(this, arguments) || this;
                return t._callTimes = 0,
                t
            }
            return i(t, e),
            t.prototype.resetParams = function(t) {
                void 0 === t && (t = -1),
                this.nodeInfo.root.active = !0,
                e.prototype.resetParams.call(this),
                ++this._callTimes,
                t > 0 && setTimeout(this.clear.bind(this), 1e3 * t)
            }
            ,
            t.prototype.isReset = function() {
                return !0
            }
            ,
            t.prototype.clear = function() {
                --this._callTimes <= 0 && (this._callTimes = 0,
                e.prototype.clear.call(this),
                this.nodeInfo.root.active = !1)
            }
            ,
            t
        }(s.default);
        o.AutoHideTip = f;
        var h = function() {
            function e(e) {
                this._root = e
            }
            return Object.defineProperty(e.prototype, "root", {
                get: function() {
                    return this._root
                },
                enumerable: !1,
                configurable: !0
            }),
            e.prototype.start = function() {
                r.default.nodeZoomIn(this._root, .2)
            }
            ,
            e
        }();
        o.PopupMethod = h;
        var d = function(e) {
            function t() {
                return null !== e && e.apply(this, arguments) || this
            }
            return i(t, e),
            t.prototype.initParams = function() {
                var e = this.nodeInfo.root.getChildByName("root");
                this._popupMethod = new h(e)
            }
            ,
            t.prototype.resetParams = function() {
                for (var e = [], t = 0; t < arguments.length; t++)
                    e[t] = arguments[t];
                this._popupMethod.start()
            }
            ,
            t
        }(s.default);
        o.PopupBase = d,
        cc._RF.pop()
    }
    , {
        "../../LogicMgr": "LogicMgr",
        "../../common/Func": "Func",
        "../../res/DyncLoadedBase": "DyncLoadedBase"
    }],
    UIPicText: [function(e, t, o) {
        "use strict";
        cc._RF.push(t, "55860iOpn5NdJlFLMModVyf", "UIPicText"),
        Object.defineProperty(o, "__esModule", {
            value: !0
        });
        var n, i = e("../../../my/config/MutabTextDesc"), r = e("../../res/DyncMgr"), a = e("../MessageMgr"), s = e("../SpecialFunc"), c = e("../../LogicMgr"), l = null, f = null;
        function h(e) {
            for (var t = Object.create(null), o = 0; o < e.childrenCount; ++o) {
                var r = e.children[o]
                  , a = {
                    size: r.getContentSize(),
                    spt: r.getComponent(cc.Sprite).spriteFrame
                };
                t[r.name] = a
            }
            n.push(t),
            i.TextCfg[e.name] || (i.TextCfg[e.name] = {}),
            i.TextCfg[e.name].type = n.length - 1
        }
        a.MessageMgr.once(a.MessageName.LoadDyncResFinish, function() {
            r.default.getResInfo(c.ConstDefine.textMgr).then(function(e) {
                var t = e.nodeInfo.root;
                n = [];
                for (var o = t.getChildByName("uiPicText"), i = 0; i < o.childrenCount; ++i)
                    h(o.children[i]);
                o.destroy(),
                l = t.getChildByName("spritePrefab"),
                f = t.getChildByName("uiTextPrefab"),
                c.default.onTextLoad()
            })
        });
        var d = function() {
            function e(e, t) {
                this.value = 0,
                t || (t = cc.instantiate(f));
                var o = i.TextCfg[e];
                this._showNum = 0,
                this._type = o.type,
                this.root = t,
                this._sprites = [],
                this._dir = t.getComponent(cc.Layout).horizontalDirection;
                for (var n = 0; n < t.childrenCount; ++n)
                    t.children[n].destroy();
                var r = t.getComponent(cc.Layout);
                o.spacingX && (r.spacingX = o.spacingX),
                o.scale && t.setScale(o.scale)
            }
            return e.insertTextCfg = function(e, t) {
                e && (t && (e.name = t),
                h(e))
            }
            ,
            e.getTextSpriteFrame = function(e, t) {
                var o = i.TextCfg[e].type;
                return n[o][t].spt
            }
            ,
            e.prototype.setValue = function(e, t, o) {
                void 0 === t && (t = ""),
                this.value = e;
                var n = t + s.default.convertDecimalNum(e, o);
                this.setStr(n)
            }
            ,
            e.prototype.setSepValue = function(e, t, o) {
                void 0 === t && (t = ""),
                this.value = e;
                var n = s.default.converSepValue(e, o);
                this.setStr(n, t)
            }
            ,
            e.prototype.setStr = function(e, t) {
                var o;
                void 0 === t && (t = "");
                var i, r = (o = "number" == typeof e ? t + e.toString() : t + e).length;
                this.initImage(r);
                for (var a = 0; a < r; ++a) {
                    var s = n[this._type][o.charAt(a)];
                    i = this._dir ? r - a - 1 : a,
                    this._sprites[i].setContentSize(s.size),
                    this._sprites[i].getComponent(cc.Sprite).spriteFrame = s.spt
                }
            }
            ,
            e.prototype.setDir = function(e) {
                var t = !1
                  , o = this.root.getComponent(cc.Layout);
                null == e ? (t = !0,
                this._dir = o.horizontalDirection ? cc.Layout.HorizontalDirection.LEFT_TO_RIGHT : cc.Layout.HorizontalDirection.RIGHT_TO_LEFT) : this._dir != e && (t = !0,
                this._dir = e),
                t && (o.horizontalDirection = this._dir,
                this.setValue(this.value))
            }
            ,
            e.prototype.setActive = function(e) {
                this.root.active = e
            }
            ,
            e.prototype.initImage = function(e) {
                var t = this._sprites.length;
                if (t < e && this.addImage(e - t),
                this._showNum > e)
                    for (var o = e; o < this._showNum; ++o)
                        this._sprites[o].active = !1;
                else
                    for (o = this._showNum; o < e; ++o)
                        this._sprites[o].active = !0;
                this._showNum = e
            }
            ,
            e.prototype.addImage = function(e) {
                for (var t = 0; t < e; ++t) {
                    var o = cc.instantiate(l);
                    o.parent = this.root,
                    this._sprites.push(o)
                }
            }
            ,
            e
        }();
        o.default = d,
        cc._RF.pop()
    }
    , {
        "../../../my/config/MutabTextDesc": "MutabTextDesc",
        "../../LogicMgr": "LogicMgr",
        "../../res/DyncMgr": "DyncMgr",
        "../MessageMgr": "MessageMgr",
        "../SpecialFunc": "SpecialFunc"
    }],
    aes: [function(e, t, o) {
        "use strict";
        var n;
        cc._RF.push(t, "7c0b2FcU2lAeragv9jHUqhm", "aes"),
        n = function(e) {
            return function() {
                var t = e
                  , o = t.lib.BlockCipher
                  , n = t.algo
                  , i = []
                  , r = []
                  , a = []
                  , s = []
                  , c = []
                  , l = []
                  , f = []
                  , h = []
                  , d = []
                  , u = [];
                (function() {
                    for (var e = [], t = 0; t < 256; t++)
                        e[t] = t < 128 ? t << 1 : t << 1 ^ 283;
                    var o = 0
                      , n = 0;
                    for (t = 0; t < 256; t++) {
                        var p = n ^ n << 1 ^ n << 2 ^ n << 3 ^ n << 4;
                        p = p >>> 8 ^ 255 & p ^ 99,
                        i[o] = p,
                        r[p] = o;
                        var g = e[o]
                          , _ = e[g]
                          , y = e[_]
                          , m = 257 * e[p] ^ 16843008 * p;
                        a[o] = m << 24 | m >>> 8,
                        s[o] = m << 16 | m >>> 16,
                        c[o] = m << 8 | m >>> 24,
                        l[o] = m,
                        m = 16843009 * y ^ 65537 * _ ^ 257 * g ^ 16843008 * o,
                        f[p] = m << 24 | m >>> 8,
                        h[p] = m << 16 | m >>> 16,
                        d[p] = m << 8 | m >>> 24,
                        u[p] = m,
                        o ? (o = g ^ e[e[e[y ^ g]]],
                        n ^= e[e[n]]) : o = n = 1
                    }
                }
                )();
                var p = [0, 1, 2, 4, 8, 16, 32, 64, 128, 27, 54]
                  , g = n.AES = o.extend({
                    _doReset: function() {
                        if (!this._nRounds || this._keyPriorReset !== this._key) {
                            for (var e = this._keyPriorReset = this._key, t = e.words, o = e.sigBytes / 4, n = 4 * ((this._nRounds = o + 6) + 1), r = this._keySchedule = [], a = 0; a < n; a++)
                                if (a < o)
                                    r[a] = t[a];
                                else {
                                    var s = r[a - 1];
                                    a % o ? o > 6 && a % o == 4 && (s = i[s >>> 24] << 24 | i[s >>> 16 & 255] << 16 | i[s >>> 8 & 255] << 8 | i[255 & s]) : (s = i[(s = s << 8 | s >>> 24) >>> 24] << 24 | i[s >>> 16 & 255] << 16 | i[s >>> 8 & 255] << 8 | i[255 & s],
                                    s ^= p[a / o | 0] << 24),
                                    r[a] = r[a - o] ^ s
                                }
                            for (var c = this._invKeySchedule = [], l = 0; l < n; l++)
                                a = n - l,
                                s = l % 4 ? r[a] : r[a - 4],
                                c[l] = l < 4 || a <= 4 ? s : f[i[s >>> 24]] ^ h[i[s >>> 16 & 255]] ^ d[i[s >>> 8 & 255]] ^ u[i[255 & s]]
                        }
                    },
                    encryptBlock: function(e, t) {
                        this._doCryptBlock(e, t, this._keySchedule, a, s, c, l, i)
                    },
                    decryptBlock: function(e, t) {
                        var o = e[t + 1];
                        e[t + 1] = e[t + 3],
                        e[t + 3] = o,
                        this._doCryptBlock(e, t, this._invKeySchedule, f, h, d, u, r),
                        o = e[t + 1],
                        e[t + 1] = e[t + 3],
                        e[t + 3] = o
                    },
                    _doCryptBlock: function(e, t, o, n, i, r, a, s) {
                        for (var c = this._nRounds, l = e[t] ^ o[0], f = e[t + 1] ^ o[1], h = e[t + 2] ^ o[2], d = e[t + 3] ^ o[3], u = 4, p = 1; p < c; p++) {
                            var g = n[l >>> 24] ^ i[f >>> 16 & 255] ^ r[h >>> 8 & 255] ^ a[255 & d] ^ o[u++]
                              , _ = n[f >>> 24] ^ i[h >>> 16 & 255] ^ r[d >>> 8 & 255] ^ a[255 & l] ^ o[u++]
                              , y = n[h >>> 24] ^ i[d >>> 16 & 255] ^ r[l >>> 8 & 255] ^ a[255 & f] ^ o[u++]
                              , m = n[d >>> 24] ^ i[l >>> 16 & 255] ^ r[f >>> 8 & 255] ^ a[255 & h] ^ o[u++];
                            l = g,
                            f = _,
                            h = y,
                            d = m
                        }
                        g = (s[l >>> 24] << 24 | s[f >>> 16 & 255] << 16 | s[h >>> 8 & 255] << 8 | s[255 & d]) ^ o[u++],
                        _ = (s[f >>> 24] << 24 | s[h >>> 16 & 255] << 16 | s[d >>> 8 & 255] << 8 | s[255 & l]) ^ o[u++],
                        y = (s[h >>> 24] << 24 | s[d >>> 16 & 255] << 16 | s[l >>> 8 & 255] << 8 | s[255 & f]) ^ o[u++],
                        m = (s[d >>> 24] << 24 | s[l >>> 16 & 255] << 16 | s[f >>> 8 & 255] << 8 | s[255 & h]) ^ o[u++],
                        e[t] = g,
                        e[t + 1] = _,
                        e[t + 2] = y,
                        e[t + 3] = m
                    },
                    keySize: 8
                });
                t.AES = o._createHelper(g)
            }(),
            e.AES
        }
        ,
        "object" == typeof o ? t.exports = o = n(e("./core"), e("./enc-base64"), e("./md5"), e("./evpkdf"), e("./cipher-core")) : "function" == typeof define && define.amd ? define(["./core", "./enc-base64", "./md5", "./evpkdf", "./cipher-core"], n) : n((void 0).CryptoJS),
        cc._RF.pop()
    }
    , {
        "./cipher-core": "cipher-core",
        "./core": "core",
        "./enc-base64": "enc-base64",
        "./evpkdf": "evpkdf",
        "./md5": "md5"
    }],
    "cipher-core": [function(e, t, o) {
        "use strict";
        var n;
        cc._RF.push(t, "7727finVORC0I+RuLWG+KYf", "cipher-core"),
        n = function(e) {
            e.lib.Cipher || function(t) {
                var o = e
                  , n = o.lib
                  , i = n.Base
                  , r = n.WordArray
                  , a = n.BufferedBlockAlgorithm
                  , s = o.enc
                  , c = (s.Utf8,
                s.Base64)
                  , l = o.algo.EvpKDF
                  , f = n.Cipher = a.extend({
                    cfg: i.extend(),
                    createEncryptor: function(e, t) {
                        return this.create(this._ENC_XFORM_MODE, e, t)
                    },
                    createDecryptor: function(e, t) {
                        return this.create(this._DEC_XFORM_MODE, e, t)
                    },
                    init: function(e, t, o) {
                        this.cfg = this.cfg.extend(o),
                        this._xformMode = e,
                        this._key = t,
                        this.reset()
                    },
                    reset: function() {
                        a.reset.call(this),
                        this._doReset()
                    },
                    process: function(e) {
                        return this._append(e),
                        this._process()
                    },
                    finalize: function(e) {
                        return e && this._append(e),
                        this._doFinalize()
                    },
                    keySize: 4,
                    ivSize: 4,
                    _ENC_XFORM_MODE: 1,
                    _DEC_XFORM_MODE: 2,
                    _createHelper: function() {
                        function e(e) {
                            return "string" == typeof e ? v : y
                        }
                        return function(t) {
                            return {
                                encrypt: function(o, n, i) {
                                    return e(n).encrypt(t, o, n, i)
                                },
                                decrypt: function(o, n, i) {
                                    return e(n).decrypt(t, o, n, i)
                                }
                            }
                        }
                    }()
                })
                  , h = (n.StreamCipher = f.extend({
                    _doFinalize: function() {
                        return this._process(!0)
                    },
                    blockSize: 1
                }),
                o.mode = {})
                  , d = n.BlockCipherMode = i.extend({
                    createEncryptor: function(e, t) {
                        return this.Encryptor.create(e, t)
                    },
                    createDecryptor: function(e, t) {
                        return this.Decryptor.create(e, t)
                    },
                    init: function(e, t) {
                        this._cipher = e,
                        this._iv = t
                    }
                })
                  , u = h.CBC = function() {
                    var e = d.extend();
                    function o(e, o, n) {
                        var i = this._iv;
                        if (i) {
                            var r = i;
                            this._iv = t
                        } else
                            r = this._prevBlock;
                        for (var a = 0; a < n; a++)
                            e[o + a] ^= r[a]
                    }
                    return e.Encryptor = e.extend({
                        processBlock: function(e, t) {
                            var n = this._cipher
                              , i = n.blockSize;
                            o.call(this, e, t, i),
                            n.encryptBlock(e, t),
                            this._prevBlock = e.slice(t, t + i)
                        }
                    }),
                    e.Decryptor = e.extend({
                        processBlock: function(e, t) {
                            var n = this._cipher
                              , i = n.blockSize
                              , r = e.slice(t, t + i);
                            n.decryptBlock(e, t),
                            o.call(this, e, t, i),
                            this._prevBlock = r
                        }
                    }),
                    e
                }()
                  , p = (o.pad = {}).Pkcs7 = {
                    pad: function(e, t) {
                        for (var o = 4 * t, n = o - e.sigBytes % o, i = n << 24 | n << 16 | n << 8 | n, a = [], s = 0; s < n; s += 4)
                            a.push(i);
                        var c = r.create(a, n);
                        e.concat(c)
                    },
                    unpad: function(e) {
                        var t = 255 & e.words[e.sigBytes - 1 >>> 2];
                        e.sigBytes -= t
                    }
                }
                  , g = (n.BlockCipher = f.extend({
                    cfg: f.cfg.extend({
                        mode: u,
                        padding: p
                    }),
                    reset: function() {
                        f.reset.call(this);
                        var e = this.cfg
                          , t = e.iv
                          , o = e.mode;
                        if (this._xformMode == this._ENC_XFORM_MODE)
                            var n = o.createEncryptor;
                        else
                            n = o.createDecryptor,
                            this._minBufferSize = 1;
                        this._mode && this._mode.__creator == n ? this._mode.init(this, t && t.words) : (this._mode = n.call(o, this, t && t.words),
                        this._mode.__creator = n)
                    },
                    _doProcessBlock: function(e, t) {
                        this._mode.processBlock(e, t)
                    },
                    _doFinalize: function() {
                        var e = this.cfg.padding;
                        if (this._xformMode == this._ENC_XFORM_MODE) {
                            e.pad(this._data, this.blockSize);
                            var t = this._process(!0)
                        } else
                            t = this._process(!0),
                            e.unpad(t);
                        return t
                    },
                    blockSize: 4
                }),
                n.CipherParams = i.extend({
                    init: function(e) {
                        this.mixIn(e)
                    },
                    toString: function(e) {
                        return (e || this.formatter).stringify(this)
                    }
                }))
                  , _ = (o.format = {}).OpenSSL = {
                    stringify: function(e) {
                        var t = e.ciphertext
                          , o = e.salt;
                        if (o)
                            var n = r.create([1398893684, 1701076831]).concat(o).concat(t);
                        else
                            n = t;
                        return n.toString(c)
                    },
                    parse: function(e) {
                        var t = c.parse(e)
                          , o = t.words;
                        if (1398893684 == o[0] && 1701076831 == o[1]) {
                            var n = r.create(o.slice(2, 4));
                            o.splice(0, 4),
                            t.sigBytes -= 16
                        }
                        return g.create({
                            ciphertext: t,
                            salt: n
                        })
                    }
                }
                  , y = n.SerializableCipher = i.extend({
                    cfg: i.extend({
                        format: _
                    }),
                    encrypt: function(e, t, o, n) {
                        n = this.cfg.extend(n);
                        var i = e.createEncryptor(o, n)
                          , r = i.finalize(t)
                          , a = i.cfg;
                        return g.create({
                            ciphertext: r,
                            key: o,
                            iv: a.iv,
                            algorithm: e,
                            mode: a.mode,
                            padding: a.padding,
                            blockSize: e.blockSize,
                            formatter: n.format
                        })
                    },
                    decrypt: function(e, t, o, n) {
                        return n = this.cfg.extend(n),
                        t = this._parse(t, n.format),
                        e.createDecryptor(o, n).finalize(t.ciphertext)
                    },
                    _parse: function(e, t) {
                        return "string" == typeof e ? t.parse(e, this) : e
                    }
                })
                  , m = (o.kdf = {}).OpenSSL = {
                    execute: function(e, t, o, n) {
                        n || (n = r.random(8));
                        var i = l.create({
                            keySize: t + o
                        }).compute(e, n)
                          , a = r.create(i.words.slice(t), 4 * o);
                        return i.sigBytes = 4 * t,
                        g.create({
                            key: i,
                            iv: a,
                            salt: n
                        })
                    }
                }
                  , v = n.PasswordBasedCipher = y.extend({
                    cfg: y.cfg.extend({
                        kdf: m
                    }),
                    encrypt: function(e, t, o, n) {
                        var i = (n = this.cfg.extend(n)).kdf.execute(o, e.keySize, e.ivSize);
                        n.iv = i.iv;
                        var r = y.encrypt.call(this, e, t, i.key, n);
                        return r.mixIn(i),
                        r
                    },
                    decrypt: function(e, t, o, n) {
                        n = this.cfg.extend(n),
                        t = this._parse(t, n.format);
                        var i = n.kdf.execute(o, e.keySize, e.ivSize, t.salt);
                        return n.iv = i.iv,
                        y.decrypt.call(this, e, t, i.key, n)
                    }
                })
            }()
        }
        ,
        "object" == typeof o ? t.exports = o = n(e("./core"), e("./evpkdf")) : "function" == typeof define && define.amd ? define(["./core", "./evpkdf"], n) : n((void 0).CryptoJS),
        cc._RF.pop()
    }
    , {
        "./core": "core",
        "./evpkdf": "evpkdf"
    }],
    core: [function(e, t, o) {
        "use strict";
        var n;
        cc._RF.push(t, "477d6XNuaxAtZpTVHnfGFhD", "core"),
        n = function() {
            var e = e || function(e) {
                var t = Object.create || function() {
                    function e() {}
                    return function(t) {
                        var o;
                        return e.prototype = t,
                        o = new e,
                        e.prototype = null,
                        o
                    }
                }()
                  , o = {}
                  , n = o.lib = {}
                  , i = n.Base = {
                    extend: function(e) {
                        var o = t(this);
                        return e && o.mixIn(e),
                        o.hasOwnProperty("init") && this.init !== o.init || (o.init = function() {
                            o.$super.init.apply(this, arguments)
                        }
                        ),
                        o.init.prototype = o,
                        o.$super = this,
                        o
                    },
                    create: function() {
                        var e = this.extend();
                        return e.init.apply(e, arguments),
                        e
                    },
                    init: function() {},
                    mixIn: function(e) {
                        for (var t in e)
                            e.hasOwnProperty(t) && (this[t] = e[t]);
                        e.hasOwnProperty("toString") && (this.toString = e.toString)
                    },
                    clone: function() {
                        return this.init.prototype.extend(this)
                    }
                }
                  , r = n.WordArray = i.extend({
                    init: function(e, t) {
                        e = this.words = e || [],
                        this.sigBytes = null != t ? t : 4 * e.length
                    },
                    toString: function(e) {
                        return (e || s).stringify(this)
                    },
                    concat: function(e) {
                        var t = this.words
                          , o = e.words
                          , n = this.sigBytes
                          , i = e.sigBytes;
                        if (this.clamp(),
                        n % 4)
                            for (var r = 0; r < i; r++) {
                                var a = o[r >>> 2] >>> 24 - r % 4 * 8 & 255;
                                t[n + r >>> 2] |= a << 24 - (n + r) % 4 * 8
                            }
                        else
                            for (r = 0; r < i; r += 4)
                                t[n + r >>> 2] = o[r >>> 2];
                        return this.sigBytes += i,
                        this
                    },
                    clamp: function() {
                        var t = this.words
                          , o = this.sigBytes;
                        t[o >>> 2] &= 4294967295 << 32 - o % 4 * 8,
                        t.length = e.ceil(o / 4)
                    },
                    clone: function() {
                        var e = i.clone.call(this);
                        return e.words = this.words.slice(0),
                        e
                    },
                    random: function(t) {
                        for (var o, n = [], i = function(t) {
                            t = t;
                            var o = 987654321
                              , n = 4294967295;
                            return function() {
                                var i = ((o = 36969 * (65535 & o) + (o >> 16) & n) << 16) + (t = 18e3 * (65535 & t) + (t >> 16) & n) & n;
                                return i /= 4294967296,
                                (i += .5) * (e.random() > .5 ? 1 : -1)
                            }
                        }, a = 0; a < t; a += 4) {
                            var s = i(4294967296 * (o || e.random()));
                            o = 987654071 * s(),
                            n.push(4294967296 * s() | 0)
                        }
                        return new r.init(n,t)
                    }
                })
                  , a = o.enc = {}
                  , s = a.Hex = {
                    stringify: function(e) {
                        for (var t = e.words, o = e.sigBytes, n = [], i = 0; i < o; i++) {
                            var r = t[i >>> 2] >>> 24 - i % 4 * 8 & 255;
                            n.push((r >>> 4).toString(16)),
                            n.push((15 & r).toString(16))
                        }
                        return n.join("")
                    },
                    parse: function(e) {
                        for (var t = e.length, o = [], n = 0; n < t; n += 2)
                            o[n >>> 3] |= parseInt(e.substr(n, 2), 16) << 24 - n % 8 * 4;
                        return new r.init(o,t / 2)
                    }
                }
                  , c = a.Latin1 = {
                    stringify: function(e) {
                        for (var t = e.words, o = e.sigBytes, n = [], i = 0; i < o; i++) {
                            var r = t[i >>> 2] >>> 24 - i % 4 * 8 & 255;
                            n.push(String.fromCharCode(r))
                        }
                        return n.join("")
                    },
                    parse: function(e) {
                        for (var t = e.length, o = [], n = 0; n < t; n++)
                            o[n >>> 2] |= (255 & e.charCodeAt(n)) << 24 - n % 4 * 8;
                        return new r.init(o,t)
                    }
                }
                  , l = a.Utf8 = {
                    stringify: function(e) {
                        try {
                            return decodeURIComponent(escape(c.stringify(e)))
                        } catch (t) {
                            throw new Error("Malformed UTF-8 data")
                        }
                    },
                    parse: function(e) {
                        return c.parse(unescape(encodeURIComponent(e)))
                    }
                }
                  , f = n.BufferedBlockAlgorithm = i.extend({
                    reset: function() {
                        this._data = new r.init,
                        this._nDataBytes = 0
                    },
                    _append: function(e) {
                        "string" == typeof e && (e = l.parse(e)),
                        this._data.concat(e),
                        this._nDataBytes += e.sigBytes
                    },
                    _process: function(t) {
                        var o = this._data
                          , n = o.words
                          , i = o.sigBytes
                          , a = this.blockSize
                          , s = i / (4 * a)
                          , c = (s = t ? e.ceil(s) : e.max((0 | s) - this._minBufferSize, 0)) * a
                          , l = e.min(4 * c, i);
                        if (c) {
                            for (var f = 0; f < c; f += a)
                                this._doProcessBlock(n, f);
                            var h = n.splice(0, c);
                            o.sigBytes -= l
                        }
                        return new r.init(h,l)
                    },
                    clone: function() {
                        var e = i.clone.call(this);
                        return e._data = this._data.clone(),
                        e
                    },
                    _minBufferSize: 0
                })
                  , h = (n.Hasher = f.extend({
                    cfg: i.extend(),
                    init: function(e) {
                        this.cfg = this.cfg.extend(e),
                        this.reset()
                    },
                    reset: function() {
                        f.reset.call(this),
                        this._doReset()
                    },
                    update: function(e) {
                        return this._append(e),
                        this._process(),
                        this
                    },
                    finalize: function(e) {
                        return e && this._append(e),
                        this._doFinalize()
                    },
                    blockSize: 16,
                    _createHelper: function(e) {
                        return function(t, o) {
                            return new e.init(o).finalize(t)
                        }
                    },
                    _createHmacHelper: function(e) {
                        return function(t, o) {
                            return new h.HMAC.init(e,o).finalize(t)
                        }
                    }
                }),
                o.algo = {});
                return o
            }(Math);
            return e
        }
        ,
        "object" == typeof o ? t.exports = o = n() : "function" == typeof define && define.amd ? define([], n) : (void 0).CryptoJS = n(),
        cc._RF.pop()
    }
    , {}],
    "crypto-js": [function(e, t, o) {
        "use strict";
        var n;
        cc._RF.push(t, "fa50arzzX9Oappsa3wvgJPe", "crypto-js"),
        n = function() {
            var e, t, o, n, i, r, a, s, c, l, f = f || function(e) {
                var t = Object.create || function() {
                    function e() {}
                    return function(t) {
                        var o;
                        return e.prototype = t,
                        o = new e,
                        e.prototype = null,
                        o
                    }
                }()
                  , o = {}
                  , n = o.lib = {}
                  , i = n.Base = {
                    extend: function(e) {
                        var o = t(this);
                        return e && o.mixIn(e),
                        o.hasOwnProperty("init") && this.init !== o.init || (o.init = function() {
                            o.$super.init.apply(this, arguments)
                        }
                        ),
                        o.init.prototype = o,
                        o.$super = this,
                        o
                    },
                    create: function() {
                        var e = this.extend();
                        return e.init.apply(e, arguments),
                        e
                    },
                    init: function() {},
                    mixIn: function(e) {
                        for (var t in e)
                            e.hasOwnProperty(t) && (this[t] = e[t]);
                        e.hasOwnProperty("toString") && (this.toString = e.toString)
                    },
                    clone: function() {
                        return this.init.prototype.extend(this)
                    }
                }
                  , r = n.WordArray = i.extend({
                    init: function(e, t) {
                        e = this.words = e || [],
                        this.sigBytes = null != t ? t : 4 * e.length
                    },
                    toString: function(e) {
                        return (e || s).stringify(this)
                    },
                    concat: function(e) {
                        var t = this.words
                          , o = e.words
                          , n = this.sigBytes
                          , i = e.sigBytes;
                        if (this.clamp(),
                        n % 4)
                            for (var r = 0; r < i; r++) {
                                var a = o[r >>> 2] >>> 24 - r % 4 * 8 & 255;
                                t[n + r >>> 2] |= a << 24 - (n + r) % 4 * 8
                            }
                        else
                            for (r = 0; r < i; r += 4)
                                t[n + r >>> 2] = o[r >>> 2];
                        return this.sigBytes += i,
                        this
                    },
                    clamp: function() {
                        var t = this.words
                          , o = this.sigBytes;
                        t[o >>> 2] &= 4294967295 << 32 - o % 4 * 8,
                        t.length = e.ceil(o / 4)
                    },
                    clone: function() {
                        var e = i.clone.call(this);
                        return e.words = this.words.slice(0),
                        e
                    },
                    random: function(t) {
                        for (var o, n = [], i = function(t) {
                            t = t;
                            var o = 987654321
                              , n = 4294967295;
                            return function() {
                                var i = ((o = 36969 * (65535 & o) + (o >> 16) & n) << 16) + (t = 18e3 * (65535 & t) + (t >> 16) & n) & n;
                                return i /= 4294967296,
                                (i += .5) * (e.random() > .5 ? 1 : -1)
                            }
                        }, a = 0; a < t; a += 4) {
                            var s = i(4294967296 * (o || e.random()));
                            o = 987654071 * s(),
                            n.push(4294967296 * s() | 0)
                        }
                        return new r.init(n,t)
                    }
                })
                  , a = o.enc = {}
                  , s = a.Hex = {
                    stringify: function(e) {
                        for (var t = e.words, o = e.sigBytes, n = [], i = 0; i < o; i++) {
                            var r = t[i >>> 2] >>> 24 - i % 4 * 8 & 255;
                            n.push((r >>> 4).toString(16)),
                            n.push((15 & r).toString(16))
                        }
                        return n.join("")
                    },
                    parse: function(e) {
                        for (var t = e.length, o = [], n = 0; n < t; n += 2)
                            o[n >>> 3] |= parseInt(e.substr(n, 2), 16) << 24 - n % 8 * 4;
                        return new r.init(o,t / 2)
                    }
                }
                  , c = a.Latin1 = {
                    stringify: function(e) {
                        for (var t = e.words, o = e.sigBytes, n = [], i = 0; i < o; i++) {
                            var r = t[i >>> 2] >>> 24 - i % 4 * 8 & 255;
                            n.push(String.fromCharCode(r))
                        }
                        return n.join("")
                    },
                    parse: function(e) {
                        for (var t = e.length, o = [], n = 0; n < t; n++)
                            o[n >>> 2] |= (255 & e.charCodeAt(n)) << 24 - n % 4 * 8;
                        return new r.init(o,t)
                    }
                }
                  , l = a.Utf8 = {
                    stringify: function(e) {
                        try {
                            return decodeURIComponent(escape(c.stringify(e)))
                        } catch (t) {
                            throw new Error("Malformed UTF-8 data")
                        }
                    },
                    parse: function(e) {
                        return c.parse(unescape(encodeURIComponent(e)))
                    }
                }
                  , f = n.BufferedBlockAlgorithm = i.extend({
                    reset: function() {
                        this._data = new r.init,
                        this._nDataBytes = 0
                    },
                    _append: function(e) {
                        "string" == typeof e && (e = l.parse(e)),
                        this._data.concat(e),
                        this._nDataBytes += e.sigBytes
                    },
                    _process: function(t) {
                        var o = this._data
                          , n = o.words
                          , i = o.sigBytes
                          , a = this.blockSize
                          , s = i / (4 * a)
                          , c = (s = t ? e.ceil(s) : e.max((0 | s) - this._minBufferSize, 0)) * a
                          , l = e.min(4 * c, i);
                        if (c) {
                            for (var f = 0; f < c; f += a)
                                this._doProcessBlock(n, f);
                            var h = n.splice(0, c);
                            o.sigBytes -= l
                        }
                        return new r.init(h,l)
                    },
                    clone: function() {
                        var e = i.clone.call(this);
                        return e._data = this._data.clone(),
                        e
                    },
                    _minBufferSize: 0
                })
                  , h = (n.Hasher = f.extend({
                    cfg: i.extend(),
                    init: function(e) {
                        this.cfg = this.cfg.extend(e),
                        this.reset()
                    },
                    reset: function() {
                        f.reset.call(this),
                        this._doReset()
                    },
                    update: function(e) {
                        return this._append(e),
                        this._process(),
                        this
                    },
                    finalize: function(e) {
                        return e && this._append(e),
                        this._doFinalize()
                    },
                    blockSize: 16,
                    _createHelper: function(e) {
                        return function(t, o) {
                            return new e.init(o).finalize(t)
                        }
                    },
                    _createHmacHelper: function(e) {
                        return function(t, o) {
                            return new h.HMAC.init(e,o).finalize(t)
                        }
                    }
                }),
                o.algo = {});
                return o
            }(Math);
            return function() {
                var e = f
                  , t = e.lib.WordArray;
                function o(e, o, n) {
                    for (var i = [], r = 0, a = 0; a < o; a++)
                        if (a % 4) {
                            var s = n[e.charCodeAt(a - 1)] << a % 4 * 2
                              , c = n[e.charCodeAt(a)] >>> 6 - a % 4 * 2;
                            i[r >>> 2] |= (s | c) << 24 - r % 4 * 8,
                            r++
                        }
                    return t.create(i, r)
                }
                e.enc.Base64 = {
                    stringify: function(e) {
                        var t = e.words
                          , o = e.sigBytes
                          , n = this._map;
                        e.clamp();
                        for (var i = [], r = 0; r < o; r += 3)
                            for (var a = (t[r >>> 2] >>> 24 - r % 4 * 8 & 255) << 16 | (t[r + 1 >>> 2] >>> 24 - (r + 1) % 4 * 8 & 255) << 8 | t[r + 2 >>> 2] >>> 24 - (r + 2) % 4 * 8 & 255, s = 0; s < 4 && r + .75 * s < o; s++)
                                i.push(n.charAt(a >>> 6 * (3 - s) & 63));
                        var c = n.charAt(64);
                        if (c)
                            for (; i.length % 4; )
                                i.push(c);
                        return i.join("")
                    },
                    parse: function(e) {
                        var t = e.length
                          , n = this._map
                          , i = this._reverseMap;
                        if (!i) {
                            i = this._reverseMap = [];
                            for (var r = 0; r < n.length; r++)
                                i[n.charCodeAt(r)] = r
                        }
                        var a = n.charAt(64);
                        if (a) {
                            var s = e.indexOf(a);
                            -1 !== s && (t = s)
                        }
                        return o(e, t, i)
                    },
                    _map: "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/="
                }
            }(),
            function(e) {
                var t = f
                  , o = t.lib
                  , n = o.WordArray
                  , i = o.Hasher
                  , r = t.algo
                  , a = [];
                (function() {
                    for (var t = 0; t < 64; t++)
                        a[t] = 4294967296 * e.abs(e.sin(t + 1)) | 0
                }
                )();
                var s = r.MD5 = i.extend({
                    _doReset: function() {
                        this._hash = new n.init([1732584193, 4023233417, 2562383102, 271733878])
                    },
                    _doProcessBlock: function(e, t) {
                        for (var o = 0; o < 16; o++) {
                            var n = t + o
                              , i = e[n];
                            e[n] = 16711935 & (i << 8 | i >>> 24) | 4278255360 & (i << 24 | i >>> 8)
                        }
                        var r = this._hash.words
                          , s = e[t + 0]
                          , f = e[t + 1]
                          , u = e[t + 2]
                          , p = e[t + 3]
                          , g = e[t + 4]
                          , _ = e[t + 5]
                          , y = e[t + 6]
                          , m = e[t + 7]
                          , v = e[t + 8]
                          , b = e[t + 9]
                          , C = e[t + 10]
                          , M = e[t + 11]
                          , S = e[t + 12]
                          , w = e[t + 13]
                          , N = e[t + 14]
                          , B = e[t + 15]
                          , P = r[0]
                          , k = r[1]
                          , R = r[2]
                          , T = r[3];
                        P = c(P, k, R, T, s, 7, a[0]),
                        T = c(T, P, k, R, f, 12, a[1]),
                        R = c(R, T, P, k, u, 17, a[2]),
                        k = c(k, R, T, P, p, 22, a[3]),
                        P = c(P, k, R, T, g, 7, a[4]),
                        T = c(T, P, k, R, _, 12, a[5]),
                        R = c(R, T, P, k, y, 17, a[6]),
                        k = c(k, R, T, P, m, 22, a[7]),
                        P = c(P, k, R, T, v, 7, a[8]),
                        T = c(T, P, k, R, b, 12, a[9]),
                        R = c(R, T, P, k, C, 17, a[10]),
                        k = c(k, R, T, P, M, 22, a[11]),
                        P = c(P, k, R, T, S, 7, a[12]),
                        T = c(T, P, k, R, w, 12, a[13]),
                        R = c(R, T, P, k, N, 17, a[14]),
                        P = l(P, k = c(k, R, T, P, B, 22, a[15]), R, T, f, 5, a[16]),
                        T = l(T, P, k, R, y, 9, a[17]),
                        R = l(R, T, P, k, M, 14, a[18]),
                        k = l(k, R, T, P, s, 20, a[19]),
                        P = l(P, k, R, T, _, 5, a[20]),
                        T = l(T, P, k, R, C, 9, a[21]),
                        R = l(R, T, P, k, B, 14, a[22]),
                        k = l(k, R, T, P, g, 20, a[23]),
                        P = l(P, k, R, T, b, 5, a[24]),
                        T = l(T, P, k, R, N, 9, a[25]),
                        R = l(R, T, P, k, p, 14, a[26]),
                        k = l(k, R, T, P, v, 20, a[27]),
                        P = l(P, k, R, T, w, 5, a[28]),
                        T = l(T, P, k, R, u, 9, a[29]),
                        R = l(R, T, P, k, m, 14, a[30]),
                        P = h(P, k = l(k, R, T, P, S, 20, a[31]), R, T, _, 4, a[32]),
                        T = h(T, P, k, R, v, 11, a[33]),
                        R = h(R, T, P, k, M, 16, a[34]),
                        k = h(k, R, T, P, N, 23, a[35]),
                        P = h(P, k, R, T, f, 4, a[36]),
                        T = h(T, P, k, R, g, 11, a[37]),
                        R = h(R, T, P, k, m, 16, a[38]),
                        k = h(k, R, T, P, C, 23, a[39]),
                        P = h(P, k, R, T, w, 4, a[40]),
                        T = h(T, P, k, R, s, 11, a[41]),
                        R = h(R, T, P, k, p, 16, a[42]),
                        k = h(k, R, T, P, y, 23, a[43]),
                        P = h(P, k, R, T, b, 4, a[44]),
                        T = h(T, P, k, R, S, 11, a[45]),
                        R = h(R, T, P, k, B, 16, a[46]),
                        P = d(P, k = h(k, R, T, P, u, 23, a[47]), R, T, s, 6, a[48]),
                        T = d(T, P, k, R, m, 10, a[49]),
                        R = d(R, T, P, k, N, 15, a[50]),
                        k = d(k, R, T, P, _, 21, a[51]),
                        P = d(P, k, R, T, S, 6, a[52]),
                        T = d(T, P, k, R, p, 10, a[53]),
                        R = d(R, T, P, k, C, 15, a[54]),
                        k = d(k, R, T, P, f, 21, a[55]),
                        P = d(P, k, R, T, v, 6, a[56]),
                        T = d(T, P, k, R, B, 10, a[57]),
                        R = d(R, T, P, k, y, 15, a[58]),
                        k = d(k, R, T, P, w, 21, a[59]),
                        P = d(P, k, R, T, g, 6, a[60]),
                        T = d(T, P, k, R, M, 10, a[61]),
                        R = d(R, T, P, k, u, 15, a[62]),
                        k = d(k, R, T, P, b, 21, a[63]),
                        r[0] = r[0] + P | 0,
                        r[1] = r[1] + k | 0,
                        r[2] = r[2] + R | 0,
                        r[3] = r[3] + T | 0
                    },
                    _doFinalize: function() {
                        var t = this._data
                          , o = t.words
                          , n = 8 * this._nDataBytes
                          , i = 8 * t.sigBytes;
                        o[i >>> 5] |= 128 << 24 - i % 32;
                        var r = e.floor(n / 4294967296)
                          , a = n;
                        o[15 + (i + 64 >>> 9 << 4)] = 16711935 & (r << 8 | r >>> 24) | 4278255360 & (r << 24 | r >>> 8),
                        o[14 + (i + 64 >>> 9 << 4)] = 16711935 & (a << 8 | a >>> 24) | 4278255360 & (a << 24 | a >>> 8),
                        t.sigBytes = 4 * (o.length + 1),
                        this._process();
                        for (var s = this._hash, c = s.words, l = 0; l < 4; l++) {
                            var f = c[l];
                            c[l] = 16711935 & (f << 8 | f >>> 24) | 4278255360 & (f << 24 | f >>> 8)
                        }
                        return s
                    },
                    clone: function() {
                        var e = i.clone.call(this);
                        return e._hash = this._hash.clone(),
                        e
                    }
                });
                function c(e, t, o, n, i, r, a) {
                    var s = e + (t & o | ~t & n) + i + a;
                    return (s << r | s >>> 32 - r) + t
                }
                function l(e, t, o, n, i, r, a) {
                    var s = e + (t & n | o & ~n) + i + a;
                    return (s << r | s >>> 32 - r) + t
                }
                function h(e, t, o, n, i, r, a) {
                    var s = e + (t ^ o ^ n) + i + a;
                    return (s << r | s >>> 32 - r) + t
                }
                function d(e, t, o, n, i, r, a) {
                    var s = e + (o ^ (t | ~n)) + i + a;
                    return (s << r | s >>> 32 - r) + t
                }
                t.MD5 = i._createHelper(s),
                t.HmacMD5 = i._createHmacHelper(s)
            }(Math),
            t = (e = f).lib,
            o = t.WordArray,
            n = t.Hasher,
            i = e.algo,
            r = [],
            a = i.SHA1 = n.extend({
                _doReset: function() {
                    this._hash = new o.init([1732584193, 4023233417, 2562383102, 271733878, 3285377520])
                },
                _doProcessBlock: function(e, t) {
                    for (var o = this._hash.words, n = o[0], i = o[1], a = o[2], s = o[3], c = o[4], l = 0; l < 80; l++) {
                        if (l < 16)
                            r[l] = 0 | e[t + l];
                        else {
                            var f = r[l - 3] ^ r[l - 8] ^ r[l - 14] ^ r[l - 16];
                            r[l] = f << 1 | f >>> 31
                        }
                        var h = (n << 5 | n >>> 27) + c + r[l];
                        h += l < 20 ? 1518500249 + (i & a | ~i & s) : l < 40 ? 1859775393 + (i ^ a ^ s) : l < 60 ? (i & a | i & s | a & s) - 1894007588 : (i ^ a ^ s) - 899497514,
                        c = s,
                        s = a,
                        a = i << 30 | i >>> 2,
                        i = n,
                        n = h
                    }
                    o[0] = o[0] + n | 0,
                    o[1] = o[1] + i | 0,
                    o[2] = o[2] + a | 0,
                    o[3] = o[3] + s | 0,
                    o[4] = o[4] + c | 0
                },
                _doFinalize: function() {
                    var e = this._data
                      , t = e.words
                      , o = 8 * this._nDataBytes
                      , n = 8 * e.sigBytes;
                    return t[n >>> 5] |= 128 << 24 - n % 32,
                    t[14 + (n + 64 >>> 9 << 4)] = Math.floor(o / 4294967296),
                    t[15 + (n + 64 >>> 9 << 4)] = o,
                    e.sigBytes = 4 * t.length,
                    this._process(),
                    this._hash
                },
                clone: function() {
                    var e = n.clone.call(this);
                    return e._hash = this._hash.clone(),
                    e
                }
            }),
            e.SHA1 = n._createHelper(a),
            e.HmacSHA1 = n._createHmacHelper(a),
            function(e) {
                var t = f
                  , o = t.lib
                  , n = o.WordArray
                  , i = o.Hasher
                  , r = t.algo
                  , a = []
                  , s = [];
                (function() {
                    function t(t) {
                        for (var o = e.sqrt(t), n = 2; n <= o; n++)
                            if (!(t % n))
                                return !1;
                        return !0
                    }
                    function o(e) {
                        return 4294967296 * (e - (0 | e)) | 0
                    }
                    for (var n = 2, i = 0; i < 64; )
                        t(n) && (i < 8 && (a[i] = o(e.pow(n, .5))),
                        s[i] = o(e.pow(n, 1 / 3)),
                        i++),
                        n++
                }
                )();
                var c = []
                  , l = r.SHA256 = i.extend({
                    _doReset: function() {
                        this._hash = new n.init(a.slice(0))
                    },
                    _doProcessBlock: function(e, t) {
                        for (var o = this._hash.words, n = o[0], i = o[1], r = o[2], a = o[3], l = o[4], f = o[5], h = o[6], d = o[7], u = 0; u < 64; u++) {
                            if (u < 16)
                                c[u] = 0 | e[t + u];
                            else {
                                var p = c[u - 15]
                                  , g = (p << 25 | p >>> 7) ^ (p << 14 | p >>> 18) ^ p >>> 3
                                  , _ = c[u - 2]
                                  , y = (_ << 15 | _ >>> 17) ^ (_ << 13 | _ >>> 19) ^ _ >>> 10;
                                c[u] = g + c[u - 7] + y + c[u - 16]
                            }
                            var m = n & i ^ n & r ^ i & r
                              , v = (n << 30 | n >>> 2) ^ (n << 19 | n >>> 13) ^ (n << 10 | n >>> 22)
                              , b = d + ((l << 26 | l >>> 6) ^ (l << 21 | l >>> 11) ^ (l << 7 | l >>> 25)) + (l & f ^ ~l & h) + s[u] + c[u];
                            d = h,
                            h = f,
                            f = l,
                            l = a + b | 0,
                            a = r,
                            r = i,
                            i = n,
                            n = b + (v + m) | 0
                        }
                        o[0] = o[0] + n | 0,
                        o[1] = o[1] + i | 0,
                        o[2] = o[2] + r | 0,
                        o[3] = o[3] + a | 0,
                        o[4] = o[4] + l | 0,
                        o[5] = o[5] + f | 0,
                        o[6] = o[6] + h | 0,
                        o[7] = o[7] + d | 0
                    },
                    _doFinalize: function() {
                        var t = this._data
                          , o = t.words
                          , n = 8 * this._nDataBytes
                          , i = 8 * t.sigBytes;
                        return o[i >>> 5] |= 128 << 24 - i % 32,
                        o[14 + (i + 64 >>> 9 << 4)] = e.floor(n / 4294967296),
                        o[15 + (i + 64 >>> 9 << 4)] = n,
                        t.sigBytes = 4 * o.length,
                        this._process(),
                        this._hash
                    },
                    clone: function() {
                        var e = i.clone.call(this);
                        return e._hash = this._hash.clone(),
                        e
                    }
                });
                t.SHA256 = i._createHelper(l),
                t.HmacSHA256 = i._createHmacHelper(l)
            }(Math),
            function() {
                var e = f
                  , t = e.lib.WordArray
                  , o = e.enc;
                function n(e) {
                    return e << 8 & 4278255360 | e >>> 8 & 16711935
                }
                o.Utf16 = o.Utf16BE = {
                    stringify: function(e) {
                        for (var t = e.words, o = e.sigBytes, n = [], i = 0; i < o; i += 2) {
                            var r = t[i >>> 2] >>> 16 - i % 4 * 8 & 65535;
                            n.push(String.fromCharCode(r))
                        }
                        return n.join("")
                    },
                    parse: function(e) {
                        for (var o = e.length, n = [], i = 0; i < o; i++)
                            n[i >>> 1] |= e.charCodeAt(i) << 16 - i % 2 * 16;
                        return t.create(n, 2 * o)
                    }
                },
                o.Utf16LE = {
                    stringify: function(e) {
                        for (var t = e.words, o = e.sigBytes, i = [], r = 0; r < o; r += 2) {
                            var a = n(t[r >>> 2] >>> 16 - r % 4 * 8 & 65535);
                            i.push(String.fromCharCode(a))
                        }
                        return i.join("")
                    },
                    parse: function(e) {
                        for (var o = e.length, i = [], r = 0; r < o; r++)
                            i[r >>> 1] |= n(e.charCodeAt(r) << 16 - r % 2 * 16);
                        return t.create(i, 2 * o)
                    }
                }
            }(),
            function() {
                if ("function" == typeof ArrayBuffer) {
                    var e = f.lib.WordArray
                      , t = e.init;
                    (e.init = function(e) {
                        if (e instanceof ArrayBuffer && (e = new Uint8Array(e)),
                        (e instanceof Int8Array || "undefined" != typeof Uint8ClampedArray && e instanceof Uint8ClampedArray || e instanceof Int16Array || e instanceof Uint16Array || e instanceof Int32Array || e instanceof Uint32Array || e instanceof Float32Array || e instanceof Float64Array) && (e = new Uint8Array(e.buffer,e.byteOffset,e.byteLength)),
                        e instanceof Uint8Array) {
                            for (var o = e.byteLength, n = [], i = 0; i < o; i++)
                                n[i >>> 2] |= e[i] << 24 - i % 4 * 8;
                            t.call(this, n, o)
                        } else
                            t.apply(this, arguments)
                    }
                    ).prototype = e
                }
            }(),
            function() {
                var e = f
                  , t = e.lib
                  , o = t.WordArray
                  , n = t.Hasher
                  , i = e.algo
                  , r = o.create([0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 7, 4, 13, 1, 10, 6, 15, 3, 12, 0, 9, 5, 2, 14, 11, 8, 3, 10, 14, 4, 9, 15, 8, 1, 2, 7, 0, 6, 13, 11, 5, 12, 1, 9, 11, 10, 0, 8, 12, 4, 13, 3, 7, 15, 14, 5, 6, 2, 4, 0, 5, 9, 7, 12, 2, 10, 14, 1, 3, 8, 11, 6, 15, 13])
                  , a = o.create([5, 14, 7, 0, 9, 2, 11, 4, 13, 6, 15, 8, 1, 10, 3, 12, 6, 11, 3, 7, 0, 13, 5, 10, 14, 15, 8, 12, 4, 9, 1, 2, 15, 5, 1, 3, 7, 14, 6, 9, 11, 8, 12, 2, 10, 0, 4, 13, 8, 6, 4, 1, 3, 11, 15, 0, 5, 12, 2, 13, 9, 7, 10, 14, 12, 15, 10, 4, 1, 5, 8, 7, 6, 2, 13, 14, 0, 3, 9, 11])
                  , s = o.create([11, 14, 15, 12, 5, 8, 7, 9, 11, 13, 14, 15, 6, 7, 9, 8, 7, 6, 8, 13, 11, 9, 7, 15, 7, 12, 15, 9, 11, 7, 13, 12, 11, 13, 6, 7, 14, 9, 13, 15, 14, 8, 13, 6, 5, 12, 7, 5, 11, 12, 14, 15, 14, 15, 9, 8, 9, 14, 5, 6, 8, 6, 5, 12, 9, 15, 5, 11, 6, 8, 13, 12, 5, 12, 13, 14, 11, 8, 5, 6])
                  , c = o.create([8, 9, 9, 11, 13, 15, 15, 5, 7, 7, 8, 11, 14, 14, 12, 6, 9, 13, 15, 7, 12, 8, 9, 11, 7, 7, 12, 7, 6, 15, 13, 11, 9, 7, 15, 11, 8, 6, 6, 14, 12, 13, 5, 14, 13, 13, 7, 5, 15, 5, 8, 11, 14, 14, 6, 14, 6, 9, 12, 9, 12, 5, 15, 8, 8, 5, 12, 9, 12, 5, 14, 6, 8, 13, 6, 5, 15, 13, 11, 11])
                  , l = o.create([0, 1518500249, 1859775393, 2400959708, 2840853838])
                  , h = o.create([1352829926, 1548603684, 1836072691, 2053994217, 0])
                  , d = i.RIPEMD160 = n.extend({
                    _doReset: function() {
                        this._hash = o.create([1732584193, 4023233417, 2562383102, 271733878, 3285377520])
                    },
                    _doProcessBlock: function(e, t) {
                        for (var o = 0; o < 16; o++) {
                            var n = t + o
                              , i = e[n];
                            e[n] = 16711935 & (i << 8 | i >>> 24) | 4278255360 & (i << 24 | i >>> 8)
                        }
                        var f, d, v, b, C, M, S, w, N, B, P, k = this._hash.words, R = l.words, T = h.words, I = r.words, D = a.words, L = s.words, x = c.words;
                        for (M = f = k[0],
                        S = d = k[1],
                        w = v = k[2],
                        N = b = k[3],
                        B = C = k[4],
                        o = 0; o < 80; o += 1)
                            P = f + e[t + I[o]] | 0,
                            P += o < 16 ? u(d, v, b) + R[0] : o < 32 ? p(d, v, b) + R[1] : o < 48 ? g(d, v, b) + R[2] : o < 64 ? _(d, v, b) + R[3] : y(d, v, b) + R[4],
                            P = (P = m(P |= 0, L[o])) + C | 0,
                            f = C,
                            C = b,
                            b = m(v, 10),
                            v = d,
                            d = P,
                            P = M + e[t + D[o]] | 0,
                            P += o < 16 ? y(S, w, N) + T[0] : o < 32 ? _(S, w, N) + T[1] : o < 48 ? g(S, w, N) + T[2] : o < 64 ? p(S, w, N) + T[3] : u(S, w, N) + T[4],
                            P = (P = m(P |= 0, x[o])) + B | 0,
                            M = B,
                            B = N,
                            N = m(w, 10),
                            w = S,
                            S = P;
                        P = k[1] + v + N | 0,
                        k[1] = k[2] + b + B | 0,
                        k[2] = k[3] + C + M | 0,
                        k[3] = k[4] + f + S | 0,
                        k[4] = k[0] + d + w | 0,
                        k[0] = P
                    },
                    _doFinalize: function() {
                        var e = this._data
                          , t = e.words
                          , o = 8 * this._nDataBytes
                          , n = 8 * e.sigBytes;
                        t[n >>> 5] |= 128 << 24 - n % 32,
                        t[14 + (n + 64 >>> 9 << 4)] = 16711935 & (o << 8 | o >>> 24) | 4278255360 & (o << 24 | o >>> 8),
                        e.sigBytes = 4 * (t.length + 1),
                        this._process();
                        for (var i = this._hash, r = i.words, a = 0; a < 5; a++) {
                            var s = r[a];
                            r[a] = 16711935 & (s << 8 | s >>> 24) | 4278255360 & (s << 24 | s >>> 8)
                        }
                        return i
                    },
                    clone: function() {
                        var e = n.clone.call(this);
                        return e._hash = this._hash.clone(),
                        e
                    }
                });
                function u(e, t, o) {
                    return e ^ t ^ o
                }
                function p(e, t, o) {
                    return e & t | ~e & o
                }
                function g(e, t, o) {
                    return (e | ~t) ^ o
                }
                function _(e, t, o) {
                    return e & o | t & ~o
                }
                function y(e, t, o) {
                    return e ^ (t | ~o)
                }
                function m(e, t) {
                    return e << t | e >>> 32 - t
                }
                e.RIPEMD160 = n._createHelper(d),
                e.HmacRIPEMD160 = n._createHmacHelper(d)
            }(Math),
            function() {
                var e = f
                  , t = e.lib.Base
                  , o = e.enc.Utf8;
                e.algo.HMAC = t.extend({
                    init: function(e, t) {
                        e = this._hasher = new e.init,
                        "string" == typeof t && (t = o.parse(t));
                        var n = e.blockSize
                          , i = 4 * n;
                        t.sigBytes > i && (t = e.finalize(t)),
                        t.clamp();
                        for (var r = this._oKey = t.clone(), a = this._iKey = t.clone(), s = r.words, c = a.words, l = 0; l < n; l++)
                            s[l] ^= 1549556828,
                            c[l] ^= 909522486;
                        r.sigBytes = a.sigBytes = i,
                        this.reset()
                    },
                    reset: function() {
                        var e = this._hasher;
                        e.reset(),
                        e.update(this._iKey)
                    },
                    update: function(e) {
                        return this._hasher.update(e),
                        this
                    },
                    finalize: function(e) {
                        var t = this._hasher
                          , o = t.finalize(e);
                        return t.reset(),
                        t.finalize(this._oKey.clone().concat(o))
                    }
                })
            }(),
            function() {
                var e = f
                  , t = e.lib
                  , o = t.Base
                  , n = t.WordArray
                  , i = e.algo
                  , r = i.SHA1
                  , a = i.HMAC
                  , s = i.PBKDF2 = o.extend({
                    cfg: o.extend({
                        keySize: 4,
                        hasher: r,
                        iterations: 1
                    }),
                    init: function(e) {
                        this.cfg = this.cfg.extend(e)
                    },
                    compute: function(e, t) {
                        for (var o = this.cfg, i = a.create(o.hasher, e), r = n.create(), s = n.create([1]), c = r.words, l = s.words, f = o.keySize, h = o.iterations; c.length < f; ) {
                            var d = i.update(t).finalize(s);
                            i.reset();
                            for (var u = d.words, p = u.length, g = d, _ = 1; _ < h; _++) {
                                g = i.finalize(g),
                                i.reset();
                                for (var y = g.words, m = 0; m < p; m++)
                                    u[m] ^= y[m]
                            }
                            r.concat(d),
                            l[0]++
                        }
                        return r.sigBytes = 4 * f,
                        r
                    }
                });
                e.PBKDF2 = function(e, t, o) {
                    return s.create(o).compute(e, t)
                }
            }(),
            function() {
                var e = f
                  , t = e.lib
                  , o = t.Base
                  , n = t.WordArray
                  , i = e.algo
                  , r = i.MD5
                  , a = i.EvpKDF = o.extend({
                    cfg: o.extend({
                        keySize: 4,
                        hasher: r,
                        iterations: 1
                    }),
                    init: function(e) {
                        this.cfg = this.cfg.extend(e)
                    },
                    compute: function(e, t) {
                        for (var o = this.cfg, i = o.hasher.create(), r = n.create(), a = r.words, s = o.keySize, c = o.iterations; a.length < s; ) {
                            l && i.update(l);
                            var l = i.update(e).finalize(t);
                            i.reset();
                            for (var f = 1; f < c; f++)
                                l = i.finalize(l),
                                i.reset();
                            r.concat(l)
                        }
                        return r.sigBytes = 4 * s,
                        r
                    }
                });
                e.EvpKDF = function(e, t, o) {
                    return a.create(o).compute(e, t)
                }
            }(),
            function() {
                var e = f
                  , t = e.lib.WordArray
                  , o = e.algo
                  , n = o.SHA256
                  , i = o.SHA224 = n.extend({
                    _doReset: function() {
                        this._hash = new t.init([3238371032, 914150663, 812702999, 4144912697, 4290775857, 1750603025, 1694076839, 3204075428])
                    },
                    _doFinalize: function() {
                        var e = n._doFinalize.call(this);
                        return e.sigBytes -= 4,
                        e
                    }
                });
                e.SHA224 = n._createHelper(i),
                e.HmacSHA224 = n._createHmacHelper(i)
            }(),
            function() {
                var e = f
                  , t = e.lib
                  , o = t.Base
                  , n = t.WordArray
                  , i = e.x64 = {};
                i.Word = o.extend({
                    init: function(e, t) {
                        this.high = e,
                        this.low = t
                    }
                }),
                i.WordArray = o.extend({
                    init: function(e, t) {
                        e = this.words = e || [],
                        this.sigBytes = null != t ? t : 8 * e.length
                    },
                    toX32: function() {
                        for (var e = this.words, t = e.length, o = [], i = 0; i < t; i++) {
                            var r = e[i];
                            o.push(r.high),
                            o.push(r.low)
                        }
                        return n.create(o, this.sigBytes)
                    },
                    clone: function() {
                        for (var e = o.clone.call(this), t = e.words = this.words.slice(0), n = t.length, i = 0; i < n; i++)
                            t[i] = t[i].clone();
                        return e
                    }
                })
            }(),
            function(e) {
                var t = f
                  , o = t.lib
                  , n = o.WordArray
                  , i = o.Hasher
                  , r = t.x64.Word
                  , a = t.algo
                  , s = []
                  , c = []
                  , l = [];
                (function() {
                    for (var e = 1, t = 0, o = 0; o < 24; o++) {
                        s[e + 5 * t] = (o + 1) * (o + 2) / 2 % 64;
                        var n = (2 * e + 3 * t) % 5;
                        e = t % 5,
                        t = n
                    }
                    for (e = 0; e < 5; e++)
                        for (t = 0; t < 5; t++)
                            c[e + 5 * t] = t + (2 * e + 3 * t) % 5 * 5;
                    for (var i = 1, a = 0; a < 24; a++) {
                        for (var f = 0, h = 0, d = 0; d < 7; d++) {
                            if (1 & i) {
                                var u = (1 << d) - 1;
                                u < 32 ? h ^= 1 << u : f ^= 1 << u - 32
                            }
                            128 & i ? i = i << 1 ^ 113 : i <<= 1
                        }
                        l[a] = r.create(f, h)
                    }
                }
                )();
                var h = [];
                (function() {
                    for (var e = 0; e < 25; e++)
                        h[e] = r.create()
                }
                )();
                var d = a.SHA3 = i.extend({
                    cfg: i.cfg.extend({
                        outputLength: 512
                    }),
                    _doReset: function() {
                        for (var e = this._state = [], t = 0; t < 25; t++)
                            e[t] = new r.init;
                        this.blockSize = (1600 - 2 * this.cfg.outputLength) / 32
                    },
                    _doProcessBlock: function(e, t) {
                        for (var o = this._state, n = this.blockSize / 2, i = 0; i < n; i++) {
                            var r = e[t + 2 * i]
                              , a = e[t + 2 * i + 1];
                            r = 16711935 & (r << 8 | r >>> 24) | 4278255360 & (r << 24 | r >>> 8),
                            a = 16711935 & (a << 8 | a >>> 24) | 4278255360 & (a << 24 | a >>> 8),
                            (k = o[i]).high ^= a,
                            k.low ^= r
                        }
                        for (var f = 0; f < 24; f++) {
                            for (var d = 0; d < 5; d++) {
                                for (var u = 0, p = 0, g = 0; g < 5; g++)
                                    u ^= (k = o[d + 5 * g]).high,
                                    p ^= k.low;
                                var _ = h[d];
                                _.high = u,
                                _.low = p
                            }
                            for (d = 0; d < 5; d++) {
                                var y = h[(d + 4) % 5]
                                  , m = h[(d + 1) % 5]
                                  , v = m.high
                                  , b = m.low;
                                for (u = y.high ^ (v << 1 | b >>> 31),
                                p = y.low ^ (b << 1 | v >>> 31),
                                g = 0; g < 5; g++)
                                    (k = o[d + 5 * g]).high ^= u,
                                    k.low ^= p
                            }
                            for (var C = 1; C < 25; C++) {
                                var M = (k = o[C]).high
                                  , S = k.low
                                  , w = s[C];
                                w < 32 ? (u = M << w | S >>> 32 - w,
                                p = S << w | M >>> 32 - w) : (u = S << w - 32 | M >>> 64 - w,
                                p = M << w - 32 | S >>> 64 - w);
                                var N = h[c[C]];
                                N.high = u,
                                N.low = p
                            }
                            var B = h[0]
                              , P = o[0];
                            for (B.high = P.high,
                            B.low = P.low,
                            d = 0; d < 5; d++)
                                for (g = 0; g < 5; g++) {
                                    var k = o[C = d + 5 * g]
                                      , R = h[C]
                                      , T = h[(d + 1) % 5 + 5 * g]
                                      , I = h[(d + 2) % 5 + 5 * g];
                                    k.high = R.high ^ ~T.high & I.high,
                                    k.low = R.low ^ ~T.low & I.low
                                }
                            k = o[0];
                            var D = l[f];
                            k.high ^= D.high,
                            k.low ^= D.low
                        }
                    },
                    _doFinalize: function() {
                        var t = this._data
                          , o = t.words
                          , i = (this._nDataBytes,
                        8 * t.sigBytes)
                          , r = 32 * this.blockSize;
                        o[i >>> 5] |= 1 << 24 - i % 32,
                        o[(e.ceil((i + 1) / r) * r >>> 5) - 1] |= 128,
                        t.sigBytes = 4 * o.length,
                        this._process();
                        for (var a = this._state, s = this.cfg.outputLength / 8, c = s / 8, l = [], f = 0; f < c; f++) {
                            var h = a[f]
                              , d = h.high
                              , u = h.low;
                            d = 16711935 & (d << 8 | d >>> 24) | 4278255360 & (d << 24 | d >>> 8),
                            u = 16711935 & (u << 8 | u >>> 24) | 4278255360 & (u << 24 | u >>> 8),
                            l.push(u),
                            l.push(d)
                        }
                        return new n.init(l,s)
                    },
                    clone: function() {
                        for (var e = i.clone.call(this), t = e._state = this._state.slice(0), o = 0; o < 25; o++)
                            t[o] = t[o].clone();
                        return e
                    }
                });
                t.SHA3 = i._createHelper(d),
                t.HmacSHA3 = i._createHmacHelper(d)
            }(Math),
            function() {
                var e = f
                  , t = e.lib.Hasher
                  , o = e.x64
                  , n = o.Word
                  , i = o.WordArray
                  , r = e.algo;
                function a() {
                    return n.create.apply(n, arguments)
                }
                var s = [a(1116352408, 3609767458), a(1899447441, 602891725), a(3049323471, 3964484399), a(3921009573, 2173295548), a(961987163, 4081628472), a(1508970993, 3053834265), a(2453635748, 2937671579), a(2870763221, 3664609560), a(3624381080, 2734883394), a(310598401, 1164996542), a(607225278, 1323610764), a(1426881987, 3590304994), a(1925078388, 4068182383), a(2162078206, 991336113), a(2614888103, 633803317), a(3248222580, 3479774868), a(3835390401, 2666613458), a(4022224774, 944711139), a(264347078, 2341262773), a(604807628, 2007800933), a(770255983, 1495990901), a(1249150122, 1856431235), a(1555081692, 3175218132), a(1996064986, 2198950837), a(2554220882, 3999719339), a(2821834349, 766784016), a(2952996808, 2566594879), a(3210313671, 3203337956), a(3336571891, 1034457026), a(3584528711, 2466948901), a(113926993, 3758326383), a(338241895, 168717936), a(666307205, 1188179964), a(773529912, 1546045734), a(1294757372, 1522805485), a(1396182291, 2643833823), a(1695183700, 2343527390), a(1986661051, 1014477480), a(2177026350, 1206759142), a(2456956037, 344077627), a(2730485921, 1290863460), a(2820302411, 3158454273), a(3259730800, 3505952657), a(3345764771, 106217008), a(3516065817, 3606008344), a(3600352804, 1432725776), a(4094571909, 1467031594), a(275423344, 851169720), a(430227734, 3100823752), a(506948616, 1363258195), a(659060556, 3750685593), a(883997877, 3785050280), a(958139571, 3318307427), a(1322822218, 3812723403), a(1537002063, 2003034995), a(1747873779, 3602036899), a(1955562222, 1575990012), a(2024104815, 1125592928), a(2227730452, 2716904306), a(2361852424, 442776044), a(2428436474, 593698344), a(2756734187, 3733110249), a(3204031479, 2999351573), a(3329325298, 3815920427), a(3391569614, 3928383900), a(3515267271, 566280711), a(3940187606, 3454069534), a(4118630271, 4000239992), a(116418474, 1914138554), a(174292421, 2731055270), a(289380356, 3203993006), a(460393269, 320620315), a(685471733, 587496836), a(852142971, 1086792851), a(1017036298, 365543100), a(1126000580, 2618297676), a(1288033470, 3409855158), a(1501505948, 4234509866), a(1607167915, 987167468), a(1816402316, 1246189591)]
                  , c = [];
                (function() {
                    for (var e = 0; e < 80; e++)
                        c[e] = a()
                }
                )();
                var l = r.SHA512 = t.extend({
                    _doReset: function() {
                        this._hash = new i.init([new n.init(1779033703,4089235720), new n.init(3144134277,2227873595), new n.init(1013904242,4271175723), new n.init(2773480762,1595750129), new n.init(1359893119,2917565137), new n.init(2600822924,725511199), new n.init(528734635,4215389547), new n.init(1541459225,327033209)])
                    },
                    _doProcessBlock: function(e, t) {
                        for (var o = this._hash.words, n = o[0], i = o[1], r = o[2], a = o[3], l = o[4], f = o[5], h = o[6], d = o[7], u = n.high, p = n.low, g = i.high, _ = i.low, y = r.high, m = r.low, v = a.high, b = a.low, C = l.high, M = l.low, S = f.high, w = f.low, N = h.high, B = h.low, P = d.high, k = d.low, R = u, T = p, I = g, D = _, L = y, x = m, E = v, O = b, F = C, A = M, j = S, U = w, G = N, H = B, z = P, V = k, W = 0; W < 80; W++) {
                            var J = c[W];
                            if (W < 16)
                                var q = J.high = 0 | e[t + 2 * W]
                                  , K = J.low = 0 | e[t + 2 * W + 1];
                            else {
                                var X = c[W - 15]
                                  , Z = X.high
                                  , Y = X.low
                                  , Q = (Z >>> 1 | Y << 31) ^ (Z >>> 8 | Y << 24) ^ Z >>> 7
                                  , $ = (Y >>> 1 | Z << 31) ^ (Y >>> 8 | Z << 24) ^ (Y >>> 7 | Z << 25)
                                  , ee = c[W - 2]
                                  , te = ee.high
                                  , oe = ee.low
                                  , ne = (te >>> 19 | oe << 13) ^ (te << 3 | oe >>> 29) ^ te >>> 6
                                  , ie = (oe >>> 19 | te << 13) ^ (oe << 3 | te >>> 29) ^ (oe >>> 6 | te << 26)
                                  , re = c[W - 7]
                                  , ae = re.high
                                  , se = re.low
                                  , ce = c[W - 16]
                                  , le = ce.high
                                  , fe = ce.low;
                                q = (q = (q = Q + ae + ((K = $ + se) >>> 0 < $ >>> 0 ? 1 : 0)) + ne + ((K += ie) >>> 0 < ie >>> 0 ? 1 : 0)) + le + ((K += fe) >>> 0 < fe >>> 0 ? 1 : 0),
                                J.high = q,
                                J.low = K
                            }
                            var he, de = F & j ^ ~F & G, ue = A & U ^ ~A & H, pe = R & I ^ R & L ^ I & L, ge = T & D ^ T & x ^ D & x, _e = (R >>> 28 | T << 4) ^ (R << 30 | T >>> 2) ^ (R << 25 | T >>> 7), ye = (T >>> 28 | R << 4) ^ (T << 30 | R >>> 2) ^ (T << 25 | R >>> 7), me = (F >>> 14 | A << 18) ^ (F >>> 18 | A << 14) ^ (F << 23 | A >>> 9), ve = (A >>> 14 | F << 18) ^ (A >>> 18 | F << 14) ^ (A << 23 | F >>> 9), be = s[W], Ce = be.high, Me = be.low, Se = z + me + ((he = V + ve) >>> 0 < V >>> 0 ? 1 : 0), we = ye + ge;
                            z = G,
                            V = H,
                            G = j,
                            H = U,
                            j = F,
                            U = A,
                            F = E + (Se = (Se = (Se = Se + de + ((he += ue) >>> 0 < ue >>> 0 ? 1 : 0)) + Ce + ((he += Me) >>> 0 < Me >>> 0 ? 1 : 0)) + q + ((he += K) >>> 0 < K >>> 0 ? 1 : 0)) + ((A = O + he | 0) >>> 0 < O >>> 0 ? 1 : 0) | 0,
                            E = L,
                            O = x,
                            L = I,
                            x = D,
                            I = R,
                            D = T,
                            R = Se + (_e + pe + (we >>> 0 < ye >>> 0 ? 1 : 0)) + ((T = he + we | 0) >>> 0 < he >>> 0 ? 1 : 0) | 0
                        }
                        p = n.low = p + T,
                        n.high = u + R + (p >>> 0 < T >>> 0 ? 1 : 0),
                        _ = i.low = _ + D,
                        i.high = g + I + (_ >>> 0 < D >>> 0 ? 1 : 0),
                        m = r.low = m + x,
                        r.high = y + L + (m >>> 0 < x >>> 0 ? 1 : 0),
                        b = a.low = b + O,
                        a.high = v + E + (b >>> 0 < O >>> 0 ? 1 : 0),
                        M = l.low = M + A,
                        l.high = C + F + (M >>> 0 < A >>> 0 ? 1 : 0),
                        w = f.low = w + U,
                        f.high = S + j + (w >>> 0 < U >>> 0 ? 1 : 0),
                        B = h.low = B + H,
                        h.high = N + G + (B >>> 0 < H >>> 0 ? 1 : 0),
                        k = d.low = k + V,
                        d.high = P + z + (k >>> 0 < V >>> 0 ? 1 : 0)
                    },
                    _doFinalize: function() {
                        var e = this._data
                          , t = e.words
                          , o = 8 * this._nDataBytes
                          , n = 8 * e.sigBytes;
                        return t[n >>> 5] |= 128 << 24 - n % 32,
                        t[30 + (n + 128 >>> 10 << 5)] = Math.floor(o / 4294967296),
                        t[31 + (n + 128 >>> 10 << 5)] = o,
                        e.sigBytes = 4 * t.length,
                        this._process(),
                        this._hash.toX32()
                    },
                    clone: function() {
                        var e = t.clone.call(this);
                        return e._hash = this._hash.clone(),
                        e
                    },
                    blockSize: 32
                });
                e.SHA512 = t._createHelper(l),
                e.HmacSHA512 = t._createHmacHelper(l)
            }(),
            function() {
                var e = f
                  , t = e.x64
                  , o = t.Word
                  , n = t.WordArray
                  , i = e.algo
                  , r = i.SHA512
                  , a = i.SHA384 = r.extend({
                    _doReset: function() {
                        this._hash = new n.init([new o.init(3418070365,3238371032), new o.init(1654270250,914150663), new o.init(2438529370,812702999), new o.init(355462360,4144912697), new o.init(1731405415,4290775857), new o.init(2394180231,1750603025), new o.init(3675008525,1694076839), new o.init(1203062813,3204075428)])
                    },
                    _doFinalize: function() {
                        var e = r._doFinalize.call(this);
                        return e.sigBytes -= 16,
                        e
                    }
                });
                e.SHA384 = r._createHelper(a),
                e.HmacSHA384 = r._createHmacHelper(a)
            }(),
            f.lib.Cipher || function(e) {
                var t = f
                  , o = t.lib
                  , n = o.Base
                  , i = o.WordArray
                  , r = o.BufferedBlockAlgorithm
                  , a = t.enc
                  , s = (a.Utf8,
                a.Base64)
                  , c = t.algo.EvpKDF
                  , l = o.Cipher = r.extend({
                    cfg: n.extend(),
                    createEncryptor: function(e, t) {
                        return this.create(this._ENC_XFORM_MODE, e, t)
                    },
                    createDecryptor: function(e, t) {
                        return this.create(this._DEC_XFORM_MODE, e, t)
                    },
                    init: function(e, t, o) {
                        this.cfg = this.cfg.extend(o),
                        this._xformMode = e,
                        this._key = t,
                        this.reset()
                    },
                    reset: function() {
                        r.reset.call(this),
                        this._doReset()
                    },
                    process: function(e) {
                        return this._append(e),
                        this._process()
                    },
                    finalize: function(e) {
                        return e && this._append(e),
                        this._doFinalize()
                    },
                    keySize: 4,
                    ivSize: 4,
                    _ENC_XFORM_MODE: 1,
                    _DEC_XFORM_MODE: 2,
                    _createHelper: function() {
                        function e(e) {
                            return "string" == typeof e ? v : y
                        }
                        return function(t) {
                            return {
                                encrypt: function(o, n, i) {
                                    return e(n).encrypt(t, o, n, i)
                                },
                                decrypt: function(o, n, i) {
                                    return e(n).decrypt(t, o, n, i)
                                }
                            }
                        }
                    }()
                })
                  , h = (o.StreamCipher = l.extend({
                    _doFinalize: function() {
                        return this._process(!0)
                    },
                    blockSize: 1
                }),
                t.mode = {})
                  , d = o.BlockCipherMode = n.extend({
                    createEncryptor: function(e, t) {
                        return this.Encryptor.create(e, t)
                    },
                    createDecryptor: function(e, t) {
                        return this.Decryptor.create(e, t)
                    },
                    init: function(e, t) {
                        this._cipher = e,
                        this._iv = t
                    }
                })
                  , u = h.CBC = function() {
                    var t = d.extend();
                    function o(t, o, n) {
                        var i = this._iv;
                        if (i) {
                            var r = i;
                            this._iv = e
                        } else
                            r = this._prevBlock;
                        for (var a = 0; a < n; a++)
                            t[o + a] ^= r[a]
                    }
                    return t.Encryptor = t.extend({
                        processBlock: function(e, t) {
                            var n = this._cipher
                              , i = n.blockSize;
                            o.call(this, e, t, i),
                            n.encryptBlock(e, t),
                            this._prevBlock = e.slice(t, t + i)
                        }
                    }),
                    t.Decryptor = t.extend({
                        processBlock: function(e, t) {
                            var n = this._cipher
                              , i = n.blockSize
                              , r = e.slice(t, t + i);
                            n.decryptBlock(e, t),
                            o.call(this, e, t, i),
                            this._prevBlock = r
                        }
                    }),
                    t
                }()
                  , p = (t.pad = {}).Pkcs7 = {
                    pad: function(e, t) {
                        for (var o = 4 * t, n = o - e.sigBytes % o, r = n << 24 | n << 16 | n << 8 | n, a = [], s = 0; s < n; s += 4)
                            a.push(r);
                        var c = i.create(a, n);
                        e.concat(c)
                    },
                    unpad: function(e) {
                        var t = 255 & e.words[e.sigBytes - 1 >>> 2];
                        e.sigBytes -= t
                    }
                }
                  , g = (o.BlockCipher = l.extend({
                    cfg: l.cfg.extend({
                        mode: u,
                        padding: p
                    }),
                    reset: function() {
                        l.reset.call(this);
                        var e = this.cfg
                          , t = e.iv
                          , o = e.mode;
                        if (this._xformMode == this._ENC_XFORM_MODE)
                            var n = o.createEncryptor;
                        else
                            n = o.createDecryptor,
                            this._minBufferSize = 1;
                        this._mode && this._mode.__creator == n ? this._mode.init(this, t && t.words) : (this._mode = n.call(o, this, t && t.words),
                        this._mode.__creator = n)
                    },
                    _doProcessBlock: function(e, t) {
                        this._mode.processBlock(e, t)
                    },
                    _doFinalize: function() {
                        var e = this.cfg.padding;
                        if (this._xformMode == this._ENC_XFORM_MODE) {
                            e.pad(this._data, this.blockSize);
                            var t = this._process(!0)
                        } else
                            t = this._process(!0),
                            e.unpad(t);
                        return t
                    },
                    blockSize: 4
                }),
                o.CipherParams = n.extend({
                    init: function(e) {
                        this.mixIn(e)
                    },
                    toString: function(e) {
                        return (e || this.formatter).stringify(this)
                    }
                }))
                  , _ = (t.format = {}).OpenSSL = {
                    stringify: function(e) {
                        var t = e.ciphertext
                          , o = e.salt;
                        if (o)
                            var n = i.create([1398893684, 1701076831]).concat(o).concat(t);
                        else
                            n = t;
                        return n.toString(s)
                    },
                    parse: function(e) {
                        var t = s.parse(e)
                          , o = t.words;
                        if (1398893684 == o[0] && 1701076831 == o[1]) {
                            var n = i.create(o.slice(2, 4));
                            o.splice(0, 4),
                            t.sigBytes -= 16
                        }
                        return g.create({
                            ciphertext: t,
                            salt: n
                        })
                    }
                }
                  , y = o.SerializableCipher = n.extend({
                    cfg: n.extend({
                        format: _
                    }),
                    encrypt: function(e, t, o, n) {
                        n = this.cfg.extend(n);
                        var i = e.createEncryptor(o, n)
                          , r = i.finalize(t)
                          , a = i.cfg;
                        return g.create({
                            ciphertext: r,
                            key: o,
                            iv: a.iv,
                            algorithm: e,
                            mode: a.mode,
                            padding: a.padding,
                            blockSize: e.blockSize,
                            formatter: n.format
                        })
                    },
                    decrypt: function(e, t, o, n) {
                        return n = this.cfg.extend(n),
                        t = this._parse(t, n.format),
                        e.createDecryptor(o, n).finalize(t.ciphertext)
                    },
                    _parse: function(e, t) {
                        return "string" == typeof e ? t.parse(e, this) : e
                    }
                })
                  , m = (t.kdf = {}).OpenSSL = {
                    execute: function(e, t, o, n) {
                        n || (n = i.random(8));
                        var r = c.create({
                            keySize: t + o
                        }).compute(e, n)
                          , a = i.create(r.words.slice(t), 4 * o);
                        return r.sigBytes = 4 * t,
                        g.create({
                            key: r,
                            iv: a,
                            salt: n
                        })
                    }
                }
                  , v = o.PasswordBasedCipher = y.extend({
                    cfg: y.cfg.extend({
                        kdf: m
                    }),
                    encrypt: function(e, t, o, n) {
                        var i = (n = this.cfg.extend(n)).kdf.execute(o, e.keySize, e.ivSize);
                        n.iv = i.iv;
                        var r = y.encrypt.call(this, e, t, i.key, n);
                        return r.mixIn(i),
                        r
                    },
                    decrypt: function(e, t, o, n) {
                        n = this.cfg.extend(n),
                        t = this._parse(t, n.format);
                        var i = n.kdf.execute(o, e.keySize, e.ivSize, t.salt);
                        return n.iv = i.iv,
                        y.decrypt.call(this, e, t, i.key, n)
                    }
                })
            }(),
            f.mode.CFB = function() {
                var e = f.lib.BlockCipherMode.extend();
                function t(e, t, o, n) {
                    var i = this._iv;
                    if (i) {
                        var r = i.slice(0);
                        this._iv = void 0
                    } else
                        r = this._prevBlock;
                    n.encryptBlock(r, 0);
                    for (var a = 0; a < o; a++)
                        e[t + a] ^= r[a]
                }
                return e.Encryptor = e.extend({
                    processBlock: function(e, o) {
                        var n = this._cipher
                          , i = n.blockSize;
                        t.call(this, e, o, i, n),
                        this._prevBlock = e.slice(o, o + i)
                    }
                }),
                e.Decryptor = e.extend({
                    processBlock: function(e, o) {
                        var n = this._cipher
                          , i = n.blockSize
                          , r = e.slice(o, o + i);
                        t.call(this, e, o, i, n),
                        this._prevBlock = r
                    }
                }),
                e
            }(),
            f.mode.ECB = ((s = f.lib.BlockCipherMode.extend()).Encryptor = s.extend({
                processBlock: function(e, t) {
                    this._cipher.encryptBlock(e, t)
                }
            }),
            s.Decryptor = s.extend({
                processBlock: function(e, t) {
                    this._cipher.decryptBlock(e, t)
                }
            }),
            s),
            f.pad.AnsiX923 = {
                pad: function(e, t) {
                    var o = e.sigBytes
                      , n = 4 * t
                      , i = n - o % n
                      , r = o + i - 1;
                    e.clamp(),
                    e.words[r >>> 2] |= i << 24 - r % 4 * 8,
                    e.sigBytes += i
                },
                unpad: function(e) {
                    var t = 255 & e.words[e.sigBytes - 1 >>> 2];
                    e.sigBytes -= t
                }
            },
            f.pad.Iso10126 = {
                pad: function(e, t) {
                    var o = 4 * t
                      , n = o - e.sigBytes % o;
                    e.concat(f.lib.WordArray.random(n - 1)).concat(f.lib.WordArray.create([n << 24], 1))
                },
                unpad: function(e) {
                    var t = 255 & e.words[e.sigBytes - 1 >>> 2];
                    e.sigBytes -= t
                }
            },
            f.pad.Iso97971 = {
                pad: function(e, t) {
                    e.concat(f.lib.WordArray.create([2147483648], 1)),
                    f.pad.ZeroPadding.pad(e, t)
                },
                unpad: function(e) {
                    f.pad.ZeroPadding.unpad(e),
                    e.sigBytes--
                }
            },
            f.mode.OFB = (l = (c = f.lib.BlockCipherMode.extend()).Encryptor = c.extend({
                processBlock: function(e, t) {
                    var o = this._cipher
                      , n = o.blockSize
                      , i = this._iv
                      , r = this._keystream;
                    i && (r = this._keystream = i.slice(0),
                    this._iv = void 0),
                    o.encryptBlock(r, 0);
                    for (var a = 0; a < n; a++)
                        e[t + a] ^= r[a]
                }
            }),
            c.Decryptor = l,
            c),
            f.pad.NoPadding = {
                pad: function() {},
                unpad: function() {}
            },
            function() {
                var e = f
                  , t = e.lib.CipherParams
                  , o = e.enc.Hex;
                e.format.Hex = {
                    stringify: function(e) {
                        return e.ciphertext.toString(o)
                    },
                    parse: function(e) {
                        var n = o.parse(e);
                        return t.create({
                            ciphertext: n
                        })
                    }
                }
            }(),
            function() {
                var e = f
                  , t = e.lib.BlockCipher
                  , o = e.algo
                  , n = []
                  , i = []
                  , r = []
                  , a = []
                  , s = []
                  , c = []
                  , l = []
                  , h = []
                  , d = []
                  , u = [];
                (function() {
                    for (var e = [], t = 0; t < 256; t++)
                        e[t] = t < 128 ? t << 1 : t << 1 ^ 283;
                    var o = 0
                      , f = 0;
                    for (t = 0; t < 256; t++) {
                        var p = f ^ f << 1 ^ f << 2 ^ f << 3 ^ f << 4;
                        p = p >>> 8 ^ 255 & p ^ 99,
                        n[o] = p,
                        i[p] = o;
                        var g = e[o]
                          , _ = e[g]
                          , y = e[_]
                          , m = 257 * e[p] ^ 16843008 * p;
                        r[o] = m << 24 | m >>> 8,
                        a[o] = m << 16 | m >>> 16,
                        s[o] = m << 8 | m >>> 24,
                        c[o] = m,
                        m = 16843009 * y ^ 65537 * _ ^ 257 * g ^ 16843008 * o,
                        l[p] = m << 24 | m >>> 8,
                        h[p] = m << 16 | m >>> 16,
                        d[p] = m << 8 | m >>> 24,
                        u[p] = m,
                        o ? (o = g ^ e[e[e[y ^ g]]],
                        f ^= e[e[f]]) : o = f = 1
                    }
                }
                )();
                var p = [0, 1, 2, 4, 8, 16, 32, 64, 128, 27, 54]
                  , g = o.AES = t.extend({
                    _doReset: function() {
                        if (!this._nRounds || this._keyPriorReset !== this._key) {
                            for (var e = this._keyPriorReset = this._key, t = e.words, o = e.sigBytes / 4, i = 4 * ((this._nRounds = o + 6) + 1), r = this._keySchedule = [], a = 0; a < i; a++)
                                if (a < o)
                                    r[a] = t[a];
                                else {
                                    var s = r[a - 1];
                                    a % o ? o > 6 && a % o == 4 && (s = n[s >>> 24] << 24 | n[s >>> 16 & 255] << 16 | n[s >>> 8 & 255] << 8 | n[255 & s]) : (s = n[(s = s << 8 | s >>> 24) >>> 24] << 24 | n[s >>> 16 & 255] << 16 | n[s >>> 8 & 255] << 8 | n[255 & s],
                                    s ^= p[a / o | 0] << 24),
                                    r[a] = r[a - o] ^ s
                                }
                            for (var c = this._invKeySchedule = [], f = 0; f < i; f++)
                                a = i - f,
                                s = f % 4 ? r[a] : r[a - 4],
                                c[f] = f < 4 || a <= 4 ? s : l[n[s >>> 24]] ^ h[n[s >>> 16 & 255]] ^ d[n[s >>> 8 & 255]] ^ u[n[255 & s]]
                        }
                    },
                    encryptBlock: function(e, t) {
                        this._doCryptBlock(e, t, this._keySchedule, r, a, s, c, n)
                    },
                    decryptBlock: function(e, t) {
                        var o = e[t + 1];
                        e[t + 1] = e[t + 3],
                        e[t + 3] = o,
                        this._doCryptBlock(e, t, this._invKeySchedule, l, h, d, u, i),
                        o = e[t + 1],
                        e[t + 1] = e[t + 3],
                        e[t + 3] = o
                    },
                    _doCryptBlock: function(e, t, o, n, i, r, a, s) {
                        for (var c = this._nRounds, l = e[t] ^ o[0], f = e[t + 1] ^ o[1], h = e[t + 2] ^ o[2], d = e[t + 3] ^ o[3], u = 4, p = 1; p < c; p++) {
                            var g = n[l >>> 24] ^ i[f >>> 16 & 255] ^ r[h >>> 8 & 255] ^ a[255 & d] ^ o[u++]
                              , _ = n[f >>> 24] ^ i[h >>> 16 & 255] ^ r[d >>> 8 & 255] ^ a[255 & l] ^ o[u++]
                              , y = n[h >>> 24] ^ i[d >>> 16 & 255] ^ r[l >>> 8 & 255] ^ a[255 & f] ^ o[u++]
                              , m = n[d >>> 24] ^ i[l >>> 16 & 255] ^ r[f >>> 8 & 255] ^ a[255 & h] ^ o[u++];
                            l = g,
                            f = _,
                            h = y,
                            d = m
                        }
                        g = (s[l >>> 24] << 24 | s[f >>> 16 & 255] << 16 | s[h >>> 8 & 255] << 8 | s[255 & d]) ^ o[u++],
                        _ = (s[f >>> 24] << 24 | s[h >>> 16 & 255] << 16 | s[d >>> 8 & 255] << 8 | s[255 & l]) ^ o[u++],
                        y = (s[h >>> 24] << 24 | s[d >>> 16 & 255] << 16 | s[l >>> 8 & 255] << 8 | s[255 & f]) ^ o[u++],
                        m = (s[d >>> 24] << 24 | s[l >>> 16 & 255] << 16 | s[f >>> 8 & 255] << 8 | s[255 & h]) ^ o[u++],
                        e[t] = g,
                        e[t + 1] = _,
                        e[t + 2] = y,
                        e[t + 3] = m
                    },
                    keySize: 8
                });
                e.AES = t._createHelper(g)
            }(),
            function() {
                var e = f
                  , t = e.lib
                  , o = t.WordArray
                  , n = t.BlockCipher
                  , i = e.algo
                  , r = [57, 49, 41, 33, 25, 17, 9, 1, 58, 50, 42, 34, 26, 18, 10, 2, 59, 51, 43, 35, 27, 19, 11, 3, 60, 52, 44, 36, 63, 55, 47, 39, 31, 23, 15, 7, 62, 54, 46, 38, 30, 22, 14, 6, 61, 53, 45, 37, 29, 21, 13, 5, 28, 20, 12, 4]
                  , a = [14, 17, 11, 24, 1, 5, 3, 28, 15, 6, 21, 10, 23, 19, 12, 4, 26, 8, 16, 7, 27, 20, 13, 2, 41, 52, 31, 37, 47, 55, 30, 40, 51, 45, 33, 48, 44, 49, 39, 56, 34, 53, 46, 42, 50, 36, 29, 32]
                  , s = [1, 2, 4, 6, 8, 10, 12, 14, 15, 17, 19, 21, 23, 25, 27, 28]
                  , c = [{
                    0: 8421888,
                    268435456: 32768,
                    536870912: 8421378,
                    805306368: 2,
                    1073741824: 512,
                    1342177280: 8421890,
                    1610612736: 8389122,
                    1879048192: 8388608,
                    2147483648: 514,
                    2415919104: 8389120,
                    2684354560: 33280,
                    2952790016: 8421376,
                    3221225472: 32770,
                    3489660928: 8388610,
                    3758096384: 0,
                    4026531840: 33282,
                    134217728: 0,
                    402653184: 8421890,
                    671088640: 33282,
                    939524096: 32768,
                    1207959552: 8421888,
                    1476395008: 512,
                    1744830464: 8421378,
                    2013265920: 2,
                    2281701376: 8389120,
                    2550136832: 33280,
                    2818572288: 8421376,
                    3087007744: 8389122,
                    3355443200: 8388610,
                    3623878656: 32770,
                    3892314112: 514,
                    4160749568: 8388608,
                    1: 32768,
                    268435457: 2,
                    536870913: 8421888,
                    805306369: 8388608,
                    1073741825: 8421378,
                    1342177281: 33280,
                    1610612737: 512,
                    1879048193: 8389122,
                    2147483649: 8421890,
                    2415919105: 8421376,
                    2684354561: 8388610,
                    2952790017: 33282,
                    3221225473: 514,
                    3489660929: 8389120,
                    3758096385: 32770,
                    4026531841: 0,
                    134217729: 8421890,
                    402653185: 8421376,
                    671088641: 8388608,
                    939524097: 512,
                    1207959553: 32768,
                    1476395009: 8388610,
                    1744830465: 2,
                    2013265921: 33282,
                    2281701377: 32770,
                    2550136833: 8389122,
                    2818572289: 514,
                    3087007745: 8421888,
                    3355443201: 8389120,
                    3623878657: 0,
                    3892314113: 33280,
                    4160749569: 8421378
                }, {
                    0: 1074282512,
                    16777216: 16384,
                    33554432: 524288,
                    50331648: 1074266128,
                    67108864: 1073741840,
                    83886080: 1074282496,
                    100663296: 1073758208,
                    117440512: 16,
                    134217728: 540672,
                    150994944: 1073758224,
                    167772160: 1073741824,
                    184549376: 540688,
                    201326592: 524304,
                    218103808: 0,
                    234881024: 16400,
                    251658240: 1074266112,
                    8388608: 1073758208,
                    25165824: 540688,
                    41943040: 16,
                    58720256: 1073758224,
                    75497472: 1074282512,
                    92274688: 1073741824,
                    109051904: 524288,
                    125829120: 1074266128,
                    142606336: 524304,
                    159383552: 0,
                    176160768: 16384,
                    192937984: 1074266112,
                    209715200: 1073741840,
                    226492416: 540672,
                    243269632: 1074282496,
                    260046848: 16400,
                    268435456: 0,
                    285212672: 1074266128,
                    301989888: 1073758224,
                    318767104: 1074282496,
                    335544320: 1074266112,
                    352321536: 16,
                    369098752: 540688,
                    385875968: 16384,
                    402653184: 16400,
                    419430400: 524288,
                    436207616: 524304,
                    452984832: 1073741840,
                    469762048: 540672,
                    486539264: 1073758208,
                    503316480: 1073741824,
                    520093696: 1074282512,
                    276824064: 540688,
                    293601280: 524288,
                    310378496: 1074266112,
                    327155712: 16384,
                    343932928: 1073758208,
                    360710144: 1074282512,
                    377487360: 16,
                    394264576: 1073741824,
                    411041792: 1074282496,
                    427819008: 1073741840,
                    444596224: 1073758224,
                    461373440: 524304,
                    478150656: 0,
                    494927872: 16400,
                    511705088: 1074266128,
                    528482304: 540672
                }, {
                    0: 260,
                    1048576: 0,
                    2097152: 67109120,
                    3145728: 65796,
                    4194304: 65540,
                    5242880: 67108868,
                    6291456: 67174660,
                    7340032: 67174400,
                    8388608: 67108864,
                    9437184: 67174656,
                    10485760: 65792,
                    11534336: 67174404,
                    12582912: 67109124,
                    13631488: 65536,
                    14680064: 4,
                    15728640: 256,
                    524288: 67174656,
                    1572864: 67174404,
                    2621440: 0,
                    3670016: 67109120,
                    4718592: 67108868,
                    5767168: 65536,
                    6815744: 65540,
                    7864320: 260,
                    8912896: 4,
                    9961472: 256,
                    11010048: 67174400,
                    12058624: 65796,
                    13107200: 65792,
                    14155776: 67109124,
                    15204352: 67174660,
                    16252928: 67108864,
                    16777216: 67174656,
                    17825792: 65540,
                    18874368: 65536,
                    19922944: 67109120,
                    20971520: 256,
                    22020096: 67174660,
                    23068672: 67108868,
                    24117248: 0,
                    25165824: 67109124,
                    26214400: 67108864,
                    27262976: 4,
                    28311552: 65792,
                    29360128: 67174400,
                    30408704: 260,
                    31457280: 65796,
                    32505856: 67174404,
                    17301504: 67108864,
                    18350080: 260,
                    19398656: 67174656,
                    20447232: 0,
                    21495808: 65540,
                    22544384: 67109120,
                    23592960: 256,
                    24641536: 67174404,
                    25690112: 65536,
                    26738688: 67174660,
                    27787264: 65796,
                    28835840: 67108868,
                    29884416: 67109124,
                    30932992: 67174400,
                    31981568: 4,
                    33030144: 65792
                }, {
                    0: 2151682048,
                    65536: 2147487808,
                    131072: 4198464,
                    196608: 2151677952,
                    262144: 0,
                    327680: 4198400,
                    393216: 2147483712,
                    458752: 4194368,
                    524288: 2147483648,
                    589824: 4194304,
                    655360: 64,
                    720896: 2147487744,
                    786432: 2151678016,
                    851968: 4160,
                    917504: 4096,
                    983040: 2151682112,
                    32768: 2147487808,
                    98304: 64,
                    163840: 2151678016,
                    229376: 2147487744,
                    294912: 4198400,
                    360448: 2151682112,
                    425984: 0,
                    491520: 2151677952,
                    557056: 4096,
                    622592: 2151682048,
                    688128: 4194304,
                    753664: 4160,
                    819200: 2147483648,
                    884736: 4194368,
                    950272: 4198464,
                    1015808: 2147483712,
                    1048576: 4194368,
                    1114112: 4198400,
                    1179648: 2147483712,
                    1245184: 0,
                    1310720: 4160,
                    1376256: 2151678016,
                    1441792: 2151682048,
                    1507328: 2147487808,
                    1572864: 2151682112,
                    1638400: 2147483648,
                    1703936: 2151677952,
                    1769472: 4198464,
                    1835008: 2147487744,
                    1900544: 4194304,
                    1966080: 64,
                    2031616: 4096,
                    1081344: 2151677952,
                    1146880: 2151682112,
                    1212416: 0,
                    1277952: 4198400,
                    1343488: 4194368,
                    1409024: 2147483648,
                    1474560: 2147487808,
                    1540096: 64,
                    1605632: 2147483712,
                    1671168: 4096,
                    1736704: 2147487744,
                    1802240: 2151678016,
                    1867776: 4160,
                    1933312: 2151682048,
                    1998848: 4194304,
                    2064384: 4198464
                }, {
                    0: 128,
                    4096: 17039360,
                    8192: 262144,
                    12288: 536870912,
                    16384: 537133184,
                    20480: 16777344,
                    24576: 553648256,
                    28672: 262272,
                    32768: 16777216,
                    36864: 537133056,
                    40960: 536871040,
                    45056: 553910400,
                    49152: 553910272,
                    53248: 0,
                    57344: 17039488,
                    61440: 553648128,
                    2048: 17039488,
                    6144: 553648256,
                    10240: 128,
                    14336: 17039360,
                    18432: 262144,
                    22528: 537133184,
                    26624: 553910272,
                    30720: 536870912,
                    34816: 537133056,
                    38912: 0,
                    43008: 553910400,
                    47104: 16777344,
                    51200: 536871040,
                    55296: 553648128,
                    59392: 16777216,
                    63488: 262272,
                    65536: 262144,
                    69632: 128,
                    73728: 536870912,
                    77824: 553648256,
                    81920: 16777344,
                    86016: 553910272,
                    90112: 537133184,
                    94208: 16777216,
                    98304: 553910400,
                    102400: 553648128,
                    106496: 17039360,
                    110592: 537133056,
                    114688: 262272,
                    118784: 536871040,
                    122880: 0,
                    126976: 17039488,
                    67584: 553648256,
                    71680: 16777216,
                    75776: 17039360,
                    79872: 537133184,
                    83968: 536870912,
                    88064: 17039488,
                    92160: 128,
                    96256: 553910272,
                    100352: 262272,
                    104448: 553910400,
                    108544: 0,
                    112640: 553648128,
                    116736: 16777344,
                    120832: 262144,
                    124928: 537133056,
                    129024: 536871040
                }, {
                    0: 268435464,
                    256: 8192,
                    512: 270532608,
                    768: 270540808,
                    1024: 268443648,
                    1280: 2097152,
                    1536: 2097160,
                    1792: 268435456,
                    2048: 0,
                    2304: 268443656,
                    2560: 2105344,
                    2816: 8,
                    3072: 270532616,
                    3328: 2105352,
                    3584: 8200,
                    3840: 270540800,
                    128: 270532608,
                    384: 270540808,
                    640: 8,
                    896: 2097152,
                    1152: 2105352,
                    1408: 268435464,
                    1664: 268443648,
                    1920: 8200,
                    2176: 2097160,
                    2432: 8192,
                    2688: 268443656,
                    2944: 270532616,
                    3200: 0,
                    3456: 270540800,
                    3712: 2105344,
                    3968: 268435456,
                    4096: 268443648,
                    4352: 270532616,
                    4608: 270540808,
                    4864: 8200,
                    5120: 2097152,
                    5376: 268435456,
                    5632: 268435464,
                    5888: 2105344,
                    6144: 2105352,
                    6400: 0,
                    6656: 8,
                    6912: 270532608,
                    7168: 8192,
                    7424: 268443656,
                    7680: 270540800,
                    7936: 2097160,
                    4224: 8,
                    4480: 2105344,
                    4736: 2097152,
                    4992: 268435464,
                    5248: 268443648,
                    5504: 8200,
                    5760: 270540808,
                    6016: 270532608,
                    6272: 270540800,
                    6528: 270532616,
                    6784: 8192,
                    7040: 2105352,
                    7296: 2097160,
                    7552: 0,
                    7808: 268435456,
                    8064: 268443656
                }, {
                    0: 1048576,
                    16: 33555457,
                    32: 1024,
                    48: 1049601,
                    64: 34604033,
                    80: 0,
                    96: 1,
                    112: 34603009,
                    128: 33555456,
                    144: 1048577,
                    160: 33554433,
                    176: 34604032,
                    192: 34603008,
                    208: 1025,
                    224: 1049600,
                    240: 33554432,
                    8: 34603009,
                    24: 0,
                    40: 33555457,
                    56: 34604032,
                    72: 1048576,
                    88: 33554433,
                    104: 33554432,
                    120: 1025,
                    136: 1049601,
                    152: 33555456,
                    168: 34603008,
                    184: 1048577,
                    200: 1024,
                    216: 34604033,
                    232: 1,
                    248: 1049600,
                    256: 33554432,
                    272: 1048576,
                    288: 33555457,
                    304: 34603009,
                    320: 1048577,
                    336: 33555456,
                    352: 34604032,
                    368: 1049601,
                    384: 1025,
                    400: 34604033,
                    416: 1049600,
                    432: 1,
                    448: 0,
                    464: 34603008,
                    480: 33554433,
                    496: 1024,
                    264: 1049600,
                    280: 33555457,
                    296: 34603009,
                    312: 1,
                    328: 33554432,
                    344: 1048576,
                    360: 1025,
                    376: 34604032,
                    392: 33554433,
                    408: 34603008,
                    424: 0,
                    440: 34604033,
                    456: 1049601,
                    472: 1024,
                    488: 33555456,
                    504: 1048577
                }, {
                    0: 134219808,
                    1: 131072,
                    2: 134217728,
                    3: 32,
                    4: 131104,
                    5: 134350880,
                    6: 134350848,
                    7: 2048,
                    8: 134348800,
                    9: 134219776,
                    10: 133120,
                    11: 134348832,
                    12: 2080,
                    13: 0,
                    14: 134217760,
                    15: 133152,
                    2147483648: 2048,
                    2147483649: 134350880,
                    2147483650: 134219808,
                    2147483651: 134217728,
                    2147483652: 134348800,
                    2147483653: 133120,
                    2147483654: 133152,
                    2147483655: 32,
                    2147483656: 134217760,
                    2147483657: 2080,
                    2147483658: 131104,
                    2147483659: 134350848,
                    2147483660: 0,
                    2147483661: 134348832,
                    2147483662: 134219776,
                    2147483663: 131072,
                    16: 133152,
                    17: 134350848,
                    18: 32,
                    19: 2048,
                    20: 134219776,
                    21: 134217760,
                    22: 134348832,
                    23: 131072,
                    24: 0,
                    25: 131104,
                    26: 134348800,
                    27: 134219808,
                    28: 134350880,
                    29: 133120,
                    30: 2080,
                    31: 134217728,
                    2147483664: 131072,
                    2147483665: 2048,
                    2147483666: 134348832,
                    2147483667: 133152,
                    2147483668: 32,
                    2147483669: 134348800,
                    2147483670: 134217728,
                    2147483671: 134219808,
                    2147483672: 134350880,
                    2147483673: 134217760,
                    2147483674: 134219776,
                    2147483675: 0,
                    2147483676: 133120,
                    2147483677: 2080,
                    2147483678: 131104,
                    2147483679: 134350848
                }]
                  , l = [4160749569, 528482304, 33030144, 2064384, 129024, 8064, 504, 2147483679]
                  , h = i.DES = n.extend({
                    _doReset: function() {
                        for (var e = this._key.words, t = [], o = 0; o < 56; o++) {
                            var n = r[o] - 1;
                            t[o] = e[n >>> 5] >>> 31 - n % 32 & 1
                        }
                        for (var i = this._subKeys = [], c = 0; c < 16; c++) {
                            var l = i[c] = []
                              , f = s[c];
                            for (o = 0; o < 24; o++)
                                l[o / 6 | 0] |= t[(a[o] - 1 + f) % 28] << 31 - o % 6,
                                l[4 + (o / 6 | 0)] |= t[28 + (a[o + 24] - 1 + f) % 28] << 31 - o % 6;
                            for (l[0] = l[0] << 1 | l[0] >>> 31,
                            o = 1; o < 7; o++)
                                l[o] = l[o] >>> 4 * (o - 1) + 3;
                            l[7] = l[7] << 5 | l[7] >>> 27
                        }
                        var h = this._invSubKeys = [];
                        for (o = 0; o < 16; o++)
                            h[o] = i[15 - o]
                    },
                    encryptBlock: function(e, t) {
                        this._doCryptBlock(e, t, this._subKeys)
                    },
                    decryptBlock: function(e, t) {
                        this._doCryptBlock(e, t, this._invSubKeys)
                    },
                    _doCryptBlock: function(e, t, o) {
                        this._lBlock = e[t],
                        this._rBlock = e[t + 1],
                        d.call(this, 4, 252645135),
                        d.call(this, 16, 65535),
                        u.call(this, 2, 858993459),
                        u.call(this, 8, 16711935),
                        d.call(this, 1, 1431655765);
                        for (var n = 0; n < 16; n++) {
                            for (var i = o[n], r = this._lBlock, a = this._rBlock, s = 0, f = 0; f < 8; f++)
                                s |= c[f][((a ^ i[f]) & l[f]) >>> 0];
                            this._lBlock = a,
                            this._rBlock = r ^ s
                        }
                        var h = this._lBlock;
                        this._lBlock = this._rBlock,
                        this._rBlock = h,
                        d.call(this, 1, 1431655765),
                        u.call(this, 8, 16711935),
                        u.call(this, 2, 858993459),
                        d.call(this, 16, 65535),
                        d.call(this, 4, 252645135),
                        e[t] = this._lBlock,
                        e[t + 1] = this._rBlock
                    },
                    keySize: 2,
                    ivSize: 2,
                    blockSize: 2
                });
                function d(e, t) {
                    var o = (this._lBlock >>> e ^ this._rBlock) & t;
                    this._rBlock ^= o,
                    this._lBlock ^= o << e
                }
                function u(e, t) {
                    var o = (this._rBlock >>> e ^ this._lBlock) & t;
                    this._lBlock ^= o,
                    this._rBlock ^= o << e
                }
                e.DES = n._createHelper(h);
                var p = i.TripleDES = n.extend({
                    _doReset: function() {
                        var e = this._key.words;
                        this._des1 = h.createEncryptor(o.create(e.slice(0, 2))),
                        this._des2 = h.createEncryptor(o.create(e.slice(2, 4))),
                        this._des3 = h.createEncryptor(o.create(e.slice(4, 6)))
                    },
                    encryptBlock: function(e, t) {
                        this._des1.encryptBlock(e, t),
                        this._des2.decryptBlock(e, t),
                        this._des3.encryptBlock(e, t)
                    },
                    decryptBlock: function(e, t) {
                        this._des3.decryptBlock(e, t),
                        this._des2.encryptBlock(e, t),
                        this._des1.decryptBlock(e, t)
                    },
                    keySize: 6,
                    ivSize: 2,
                    blockSize: 2
                });
                e.TripleDES = n._createHelper(p)
            }(),
            function() {
                var e = f
                  , t = e.lib.StreamCipher
                  , o = e.algo
                  , n = o.RC4 = t.extend({
                    _doReset: function() {
                        for (var e = this._key, t = e.words, o = e.sigBytes, n = this._S = [], i = 0; i < 256; i++)
                            n[i] = i;
                        i = 0;
                        for (var r = 0; i < 256; i++) {
                            var a = i % o
                              , s = t[a >>> 2] >>> 24 - a % 4 * 8 & 255;
                            r = (r + n[i] + s) % 256;
                            var c = n[i];
                            n[i] = n[r],
                            n[r] = c
                        }
                        this._i = this._j = 0
                    },
                    _doProcessBlock: function(e, t) {
                        e[t] ^= i.call(this)
                    },
                    keySize: 8,
                    ivSize: 0
                });
                function i() {
                    for (var e = this._S, t = this._i, o = this._j, n = 0, i = 0; i < 4; i++) {
                        o = (o + e[t = (t + 1) % 256]) % 256;
                        var r = e[t];
                        e[t] = e[o],
                        e[o] = r,
                        n |= e[(e[t] + e[o]) % 256] << 24 - 8 * i
                    }
                    return this._i = t,
                    this._j = o,
                    n
                }
                e.RC4 = t._createHelper(n);
                var r = o.RC4Drop = n.extend({
                    cfg: n.cfg.extend({
                        drop: 192
                    }),
                    _doReset: function() {
                        n._doReset.call(this);
                        for (var e = this.cfg.drop; e > 0; e--)
                            i.call(this)
                    }
                });
                e.RC4Drop = t._createHelper(r)
            }(),
            f.mode.CTRGladman = function() {
                var e = f.lib.BlockCipherMode.extend();
                function t(e) {
                    if (255 == (e >> 24 & 255)) {
                        var t = e >> 16 & 255
                          , o = e >> 8 & 255
                          , n = 255 & e;
                        255 === t ? (t = 0,
                        255 === o ? (o = 0,
                        255 === n ? n = 0 : ++n) : ++o) : ++t,
                        e = 0,
                        e += t << 16,
                        e += o << 8,
                        e += n
                    } else
                        e += 1 << 24;
                    return e
                }
                function o(e) {
                    return 0 === (e[0] = t(e[0])) && (e[1] = t(e[1])),
                    e
                }
                var n = e.Encryptor = e.extend({
                    processBlock: function(e, t) {
                        var n = this._cipher
                          , i = n.blockSize
                          , r = this._iv
                          , a = this._counter;
                        r && (a = this._counter = r.slice(0),
                        this._iv = void 0),
                        o(a);
                        var s = a.slice(0);
                        n.encryptBlock(s, 0);
                        for (var c = 0; c < i; c++)
                            e[t + c] ^= s[c]
                    }
                });
                return e.Decryptor = n,
                e
            }(),
            function() {
                var e = f
                  , t = e.lib.StreamCipher
                  , o = e.algo
                  , n = []
                  , i = []
                  , r = []
                  , a = o.Rabbit = t.extend({
                    _doReset: function() {
                        for (var e = this._key.words, t = this.cfg.iv, o = 0; o < 4; o++)
                            e[o] = 16711935 & (e[o] << 8 | e[o] >>> 24) | 4278255360 & (e[o] << 24 | e[o] >>> 8);
                        var n = this._X = [e[0], e[3] << 16 | e[2] >>> 16, e[1], e[0] << 16 | e[3] >>> 16, e[2], e[1] << 16 | e[0] >>> 16, e[3], e[2] << 16 | e[1] >>> 16]
                          , i = this._C = [e[2] << 16 | e[2] >>> 16, 4294901760 & e[0] | 65535 & e[1], e[3] << 16 | e[3] >>> 16, 4294901760 & e[1] | 65535 & e[2], e[0] << 16 | e[0] >>> 16, 4294901760 & e[2] | 65535 & e[3], e[1] << 16 | e[1] >>> 16, 4294901760 & e[3] | 65535 & e[0]];
                        for (this._b = 0,
                        o = 0; o < 4; o++)
                            s.call(this);
                        for (o = 0; o < 8; o++)
                            i[o] ^= n[o + 4 & 7];
                        if (t) {
                            var r = t.words
                              , a = r[0]
                              , c = r[1]
                              , l = 16711935 & (a << 8 | a >>> 24) | 4278255360 & (a << 24 | a >>> 8)
                              , f = 16711935 & (c << 8 | c >>> 24) | 4278255360 & (c << 24 | c >>> 8)
                              , h = l >>> 16 | 4294901760 & f
                              , d = f << 16 | 65535 & l;
                            for (i[0] ^= l,
                            i[1] ^= h,
                            i[2] ^= f,
                            i[3] ^= d,
                            i[4] ^= l,
                            i[5] ^= h,
                            i[6] ^= f,
                            i[7] ^= d,
                            o = 0; o < 4; o++)
                                s.call(this)
                        }
                    },
                    _doProcessBlock: function(e, t) {
                        var o = this._X;
                        s.call(this),
                        n[0] = o[0] ^ o[5] >>> 16 ^ o[3] << 16,
                        n[1] = o[2] ^ o[7] >>> 16 ^ o[5] << 16,
                        n[2] = o[4] ^ o[1] >>> 16 ^ o[7] << 16,
                        n[3] = o[6] ^ o[3] >>> 16 ^ o[1] << 16;
                        for (var i = 0; i < 4; i++)
                            n[i] = 16711935 & (n[i] << 8 | n[i] >>> 24) | 4278255360 & (n[i] << 24 | n[i] >>> 8),
                            e[t + i] ^= n[i]
                    },
                    blockSize: 4,
                    ivSize: 2
                });
                function s() {
                    for (var e = this._X, t = this._C, o = 0; o < 8; o++)
                        i[o] = t[o];
                    for (t[0] = t[0] + 1295307597 + this._b | 0,
                    t[1] = t[1] + 3545052371 + (t[0] >>> 0 < i[0] >>> 0 ? 1 : 0) | 0,
                    t[2] = t[2] + 886263092 + (t[1] >>> 0 < i[1] >>> 0 ? 1 : 0) | 0,
                    t[3] = t[3] + 1295307597 + (t[2] >>> 0 < i[2] >>> 0 ? 1 : 0) | 0,
                    t[4] = t[4] + 3545052371 + (t[3] >>> 0 < i[3] >>> 0 ? 1 : 0) | 0,
                    t[5] = t[5] + 886263092 + (t[4] >>> 0 < i[4] >>> 0 ? 1 : 0) | 0,
                    t[6] = t[6] + 1295307597 + (t[5] >>> 0 < i[5] >>> 0 ? 1 : 0) | 0,
                    t[7] = t[7] + 3545052371 + (t[6] >>> 0 < i[6] >>> 0 ? 1 : 0) | 0,
                    this._b = t[7] >>> 0 < i[7] >>> 0 ? 1 : 0,
                    o = 0; o < 8; o++) {
                        var n = e[o] + t[o]
                          , a = 65535 & n
                          , s = n >>> 16
                          , c = ((a * a >>> 17) + a * s >>> 15) + s * s
                          , l = ((4294901760 & n) * n | 0) + ((65535 & n) * n | 0);
                        r[o] = c ^ l
                    }
                    e[0] = r[0] + (r[7] << 16 | r[7] >>> 16) + (r[6] << 16 | r[6] >>> 16) | 0,
                    e[1] = r[1] + (r[0] << 8 | r[0] >>> 24) + r[7] | 0,
                    e[2] = r[2] + (r[1] << 16 | r[1] >>> 16) + (r[0] << 16 | r[0] >>> 16) | 0,
                    e[3] = r[3] + (r[2] << 8 | r[2] >>> 24) + r[1] | 0,
                    e[4] = r[4] + (r[3] << 16 | r[3] >>> 16) + (r[2] << 16 | r[2] >>> 16) | 0,
                    e[5] = r[5] + (r[4] << 8 | r[4] >>> 24) + r[3] | 0,
                    e[6] = r[6] + (r[5] << 16 | r[5] >>> 16) + (r[4] << 16 | r[4] >>> 16) | 0,
                    e[7] = r[7] + (r[6] << 8 | r[6] >>> 24) + r[5] | 0
                }
                e.Rabbit = t._createHelper(a)
            }(),
            f.mode.CTR = function() {
                var e = f.lib.BlockCipherMode.extend()
                  , t = e.Encryptor = e.extend({
                    processBlock: function(e, t) {
                        var o = this._cipher
                          , n = o.blockSize
                          , i = this._iv
                          , r = this._counter;
                        i && (r = this._counter = i.slice(0),
                        this._iv = void 0);
                        var a = r.slice(0);
                        o.encryptBlock(a, 0),
                        r[n - 1] = r[n - 1] + 1 | 0;
                        for (var s = 0; s < n; s++)
                            e[t + s] ^= a[s]
                    }
                });
                return e.Decryptor = t,
                e
            }(),
            function() {
                var e = f
                  , t = e.lib.StreamCipher
                  , o = e.algo
                  , n = []
                  , i = []
                  , r = []
                  , a = o.RabbitLegacy = t.extend({
                    _doReset: function() {
                        var e = this._key.words
                          , t = this.cfg.iv
                          , o = this._X = [e[0], e[3] << 16 | e[2] >>> 16, e[1], e[0] << 16 | e[3] >>> 16, e[2], e[1] << 16 | e[0] >>> 16, e[3], e[2] << 16 | e[1] >>> 16]
                          , n = this._C = [e[2] << 16 | e[2] >>> 16, 4294901760 & e[0] | 65535 & e[1], e[3] << 16 | e[3] >>> 16, 4294901760 & e[1] | 65535 & e[2], e[0] << 16 | e[0] >>> 16, 4294901760 & e[2] | 65535 & e[3], e[1] << 16 | e[1] >>> 16, 4294901760 & e[3] | 65535 & e[0]];
                        this._b = 0;
                        for (var i = 0; i < 4; i++)
                            s.call(this);
                        for (i = 0; i < 8; i++)
                            n[i] ^= o[i + 4 & 7];
                        if (t) {
                            var r = t.words
                              , a = r[0]
                              , c = r[1]
                              , l = 16711935 & (a << 8 | a >>> 24) | 4278255360 & (a << 24 | a >>> 8)
                              , f = 16711935 & (c << 8 | c >>> 24) | 4278255360 & (c << 24 | c >>> 8)
                              , h = l >>> 16 | 4294901760 & f
                              , d = f << 16 | 65535 & l;
                            for (n[0] ^= l,
                            n[1] ^= h,
                            n[2] ^= f,
                            n[3] ^= d,
                            n[4] ^= l,
                            n[5] ^= h,
                            n[6] ^= f,
                            n[7] ^= d,
                            i = 0; i < 4; i++)
                                s.call(this)
                        }
                    },
                    _doProcessBlock: function(e, t) {
                        var o = this._X;
                        s.call(this),
                        n[0] = o[0] ^ o[5] >>> 16 ^ o[3] << 16,
                        n[1] = o[2] ^ o[7] >>> 16 ^ o[5] << 16,
                        n[2] = o[4] ^ o[1] >>> 16 ^ o[7] << 16,
                        n[3] = o[6] ^ o[3] >>> 16 ^ o[1] << 16;
                        for (var i = 0; i < 4; i++)
                            n[i] = 16711935 & (n[i] << 8 | n[i] >>> 24) | 4278255360 & (n[i] << 24 | n[i] >>> 8),
                            e[t + i] ^= n[i]
                    },
                    blockSize: 4,
                    ivSize: 2
                });
                function s() {
                    for (var e = this._X, t = this._C, o = 0; o < 8; o++)
                        i[o] = t[o];
                    for (t[0] = t[0] + 1295307597 + this._b | 0,
                    t[1] = t[1] + 3545052371 + (t[0] >>> 0 < i[0] >>> 0 ? 1 : 0) | 0,
                    t[2] = t[2] + 886263092 + (t[1] >>> 0 < i[1] >>> 0 ? 1 : 0) | 0,
                    t[3] = t[3] + 1295307597 + (t[2] >>> 0 < i[2] >>> 0 ? 1 : 0) | 0,
                    t[4] = t[4] + 3545052371 + (t[3] >>> 0 < i[3] >>> 0 ? 1 : 0) | 0,
                    t[5] = t[5] + 886263092 + (t[4] >>> 0 < i[4] >>> 0 ? 1 : 0) | 0,
                    t[6] = t[6] + 1295307597 + (t[5] >>> 0 < i[5] >>> 0 ? 1 : 0) | 0,
                    t[7] = t[7] + 3545052371 + (t[6] >>> 0 < i[6] >>> 0 ? 1 : 0) | 0,
                    this._b = t[7] >>> 0 < i[7] >>> 0 ? 1 : 0,
                    o = 0; o < 8; o++) {
                        var n = e[o] + t[o]
                          , a = 65535 & n
                          , s = n >>> 16
                          , c = ((a * a >>> 17) + a * s >>> 15) + s * s
                          , l = ((4294901760 & n) * n | 0) + ((65535 & n) * n | 0);
                        r[o] = c ^ l
                    }
                    e[0] = r[0] + (r[7] << 16 | r[7] >>> 16) + (r[6] << 16 | r[6] >>> 16) | 0,
                    e[1] = r[1] + (r[0] << 8 | r[0] >>> 24) + r[7] | 0,
                    e[2] = r[2] + (r[1] << 16 | r[1] >>> 16) + (r[0] << 16 | r[0] >>> 16) | 0,
                    e[3] = r[3] + (r[2] << 8 | r[2] >>> 24) + r[1] | 0,
                    e[4] = r[4] + (r[3] << 16 | r[3] >>> 16) + (r[2] << 16 | r[2] >>> 16) | 0,
                    e[5] = r[5] + (r[4] << 8 | r[4] >>> 24) + r[3] | 0,
                    e[6] = r[6] + (r[5] << 16 | r[5] >>> 16) + (r[4] << 16 | r[4] >>> 16) | 0,
                    e[7] = r[7] + (r[6] << 8 | r[6] >>> 24) + r[5] | 0
                }
                e.RabbitLegacy = t._createHelper(a)
            }(),
            f.pad.ZeroPadding = {
                pad: function(e, t) {
                    var o = 4 * t;
                    e.clamp(),
                    e.sigBytes += o - (e.sigBytes % o || o)
                },
                unpad: function(e) {
                    for (var t = e.words, o = e.sigBytes - 1; !(t[o >>> 2] >>> 24 - o % 4 * 8 & 255); )
                        o--;
                    e.sigBytes = o + 1
                }
            },
            f
        }
        ,
        "object" == typeof o ? t.exports = o = n() : "function" == typeof define && define.amd ? define([], n) : (void 0).CryptoJS = n(),
        cc._RF.pop()
    }
    , {}],
    "enc-base64": [function(e, t, o) {
        "use strict";
        var n;
        cc._RF.push(t, "34b33oLo4JEnJCWiiOufAkL", "enc-base64"),
        n = function(e) {
            return function() {
                var t = e
                  , o = t.lib.WordArray;
                function n(e, t, n) {
                    for (var i = [], r = 0, a = 0; a < t; a++)
                        if (a % 4) {
                            var s = n[e.charCodeAt(a - 1)] << a % 4 * 2
                              , c = n[e.charCodeAt(a)] >>> 6 - a % 4 * 2;
                            i[r >>> 2] |= (s | c) << 24 - r % 4 * 8,
                            r++
                        }
                    return o.create(i, r)
                }
                t.enc.Base64 = {
                    stringify: function(e) {
                        var t = e.words
                          , o = e.sigBytes
                          , n = this._map;
                        e.clamp();
                        for (var i = [], r = 0; r < o; r += 3)
                            for (var a = (t[r >>> 2] >>> 24 - r % 4 * 8 & 255) << 16 | (t[r + 1 >>> 2] >>> 24 - (r + 1) % 4 * 8 & 255) << 8 | t[r + 2 >>> 2] >>> 24 - (r + 2) % 4 * 8 & 255, s = 0; s < 4 && r + .75 * s < o; s++)
                                i.push(n.charAt(a >>> 6 * (3 - s) & 63));
                        var c = n.charAt(64);
                        if (c)
                            for (; i.length % 4; )
                                i.push(c);
                        return i.join("")
                    },
                    parse: function(e) {
                        var t = e.length
                          , o = this._map
                          , i = this._reverseMap;
                        if (!i) {
                            i = this._reverseMap = [];
                            for (var r = 0; r < o.length; r++)
                                i[o.charCodeAt(r)] = r
                        }
                        var a = o.charAt(64);
                        if (a) {
                            var s = e.indexOf(a);
                            -1 !== s && (t = s)
                        }
                        return n(e, t, i)
                    },
                    _map: "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/="
                }
            }(),
            e.enc.Base64
        }
        ,
        "object" == typeof o ? t.exports = o = n(e("./core")) : "function" == typeof define && define.amd ? define(["./core"], n) : n((void 0).CryptoJS),
        cc._RF.pop()
    }
    , {
        "./core": "core"
    }],
    "enc-hex": [function(e, t, o) {
        "use strict";
        var n;
        cc._RF.push(t, "1dc27PQNk5NeqZBPUSdvkAJ", "enc-hex"),
        n = function(e) {
            return e.enc.Hex
        }
        ,
        "object" == typeof o ? t.exports = o = n(e("./core")) : "function" == typeof define && define.amd ? define(["./core"], n) : n((void 0).CryptoJS),
        cc._RF.pop()
    }
    , {
        "./core": "core"
    }],
    "enc-latin1": [function(e, t, o) {
        "use strict";
        var n;
        cc._RF.push(t, "4b58dH0LfFFmKX3tTjU8Oj9", "enc-latin1"),
        n = function(e) {
            return e.enc.Latin1
        }
        ,
        "object" == typeof o ? t.exports = o = n(e("./core")) : "function" == typeof define && define.amd ? define(["./core"], n) : n((void 0).CryptoJS),
        cc._RF.pop()
    }
    , {
        "./core": "core"
    }],
    "enc-utf16": [function(e, t, o) {
        "use strict";
        var n;
        cc._RF.push(t, "b9ccbGKg7hCm7C+NCgYUtVV", "enc-utf16"),
        n = function(e) {
            return function() {
                var t = e
                  , o = t.lib.WordArray
                  , n = t.enc;
                function i(e) {
                    return e << 8 & 4278255360 | e >>> 8 & 16711935
                }
                n.Utf16 = n.Utf16BE = {
                    stringify: function(e) {
                        for (var t = e.words, o = e.sigBytes, n = [], i = 0; i < o; i += 2) {
                            var r = t[i >>> 2] >>> 16 - i % 4 * 8 & 65535;
                            n.push(String.fromCharCode(r))
                        }
                        return n.join("")
                    },
                    parse: function(e) {
                        for (var t = e.length, n = [], i = 0; i < t; i++)
                            n[i >>> 1] |= e.charCodeAt(i) << 16 - i % 2 * 16;
                        return o.create(n, 2 * t)
                    }
                },
                n.Utf16LE = {
                    stringify: function(e) {
                        for (var t = e.words, o = e.sigBytes, n = [], r = 0; r < o; r += 2) {
                            var a = i(t[r >>> 2] >>> 16 - r % 4 * 8 & 65535);
                            n.push(String.fromCharCode(a))
                        }
                        return n.join("")
                    },
                    parse: function(e) {
                        for (var t = e.length, n = [], r = 0; r < t; r++)
                            n[r >>> 1] |= i(e.charCodeAt(r) << 16 - r % 2 * 16);
                        return o.create(n, 2 * t)
                    }
                }
            }(),
            e.enc.Utf16
        }
        ,
        "object" == typeof o ? t.exports = o = n(e("./core")) : "function" == typeof define && define.amd ? define(["./core"], n) : n((void 0).CryptoJS),
        cc._RF.pop()
    }
    , {
        "./core": "core"
    }],
    "enc-utf8": [function(e, t, o) {
        "use strict";
        var n;
        cc._RF.push(t, "9f8b89C9ihP5bpWniuVixJe", "enc-utf8"),
        n = function(e) {
            return e.enc.Utf8
        }
        ,
        "object" == typeof o ? t.exports = o = n(e("./core")) : "function" == typeof define && define.amd ? define(["./core"], n) : n((void 0).CryptoJS),
        cc._RF.pop()
    }
    , {
        "./core": "core"
    }],
    evpkdf: [function(e, t, o) {
        "use strict";
        var n;
        cc._RF.push(t, "113b873c/tPf5jZuRsfZaYa", "evpkdf"),
        n = function(e) {
            var t, o, n, i, r, a, s;
            return n = (o = (t = e).lib).Base,
            i = o.WordArray,
            a = (r = t.algo).MD5,
            s = r.EvpKDF = n.extend({
                cfg: n.extend({
                    keySize: 4,
                    hasher: a,
                    iterations: 1
                }),
                init: function(e) {
                    this.cfg = this.cfg.extend(e)
                },
                compute: function(e, t) {
                    for (var o = this.cfg, n = o.hasher.create(), r = i.create(), a = r.words, s = o.keySize, c = o.iterations; a.length < s; ) {
                        l && n.update(l);
                        var l = n.update(e).finalize(t);
                        n.reset();
                        for (var f = 1; f < c; f++)
                            l = n.finalize(l),
                            n.reset();
                        r.concat(l)
                    }
                    return r.sigBytes = 4 * s,
                    r
                }
            }),
            t.EvpKDF = function(e, t, o) {
                return s.create(o).compute(e, t)
            }
            ,
            e.EvpKDF
        }
        ,
        "object" == typeof o ? t.exports = o = n(e("./core"), e("./sha1"), e("./hmac")) : "function" == typeof define && define.amd ? define(["./core", "./sha1", "./hmac"], n) : n((void 0).CryptoJS),
        cc._RF.pop()
    }
    , {
        "./core": "core",
        "./hmac": "hmac",
        "./sha1": "sha1"
    }],
    "format-hex": [function(e, t, o) {
        "use strict";
        var n;
        cc._RF.push(t, "39c80WO3/RLAoKpj3oOi0cW", "format-hex"),
        n = function(e) {
            var t, o, n;
            return o = (t = e).lib.CipherParams,
            n = t.enc.Hex,
            t.format.Hex = {
                stringify: function(e) {
                    return e.ciphertext.toString(n)
                },
                parse: function(e) {
                    var t = n.parse(e);
                    return o.create({
                        ciphertext: t
                    })
                }
            },
            e.format.Hex
        }
        ,
        "object" == typeof o ? t.exports = o = n(e("./core"), e("./cipher-core")) : "function" == typeof define && define.amd ? define(["./core", "./cipher-core"], n) : n((void 0).CryptoJS),
        cc._RF.pop()
    }
    , {
        "./cipher-core": "cipher-core",
        "./core": "core"
    }],
    "format-openssl": [function(e, t, o) {
        "use strict";
        var n;
        cc._RF.push(t, "65812lEIhpDNKzH+QD+kFLN", "format-openssl"),
        n = function(e) {
            return e.format.OpenSSL
        }
        ,
        "object" == typeof o ? t.exports = o = n(e("./core"), e("./cipher-core")) : "function" == typeof define && define.amd ? define(["./core", "./cipher-core"], n) : n((void 0).CryptoJS),
        cc._RF.pop()
    }
    , {
        "./cipher-core": "cipher-core",
        "./core": "core"
    }],
    "hmac-md5": [function(e, t, o) {
        "use strict";
        var n;
        cc._RF.push(t, "c52a8iINOhPiZJ2nOAEsMe0", "hmac-md5"),
        n = function(e) {
            return e.HmacMD5
        }
        ,
        "object" == typeof o ? t.exports = o = n(e("./core"), e("./md5"), e("./hmac")) : "function" == typeof define && define.amd ? define(["./core", "./md5", "./hmac"], n) : n((void 0).CryptoJS),
        cc._RF.pop()
    }
    , {
        "./core": "core",
        "./hmac": "hmac",
        "./md5": "md5"
    }],
    "hmac-ripemd160": [function(e, t, o) {
        "use strict";
        var n;
        cc._RF.push(t, "acb8enjI1dJvIP2RjWOgFcw", "hmac-ripemd160"),
        n = function(e) {
            return e.HmacRIPEMD160
        }
        ,
        "object" == typeof o ? t.exports = o = n(e("./core"), e("./ripemd160"), e("./hmac")) : "function" == typeof define && define.amd ? define(["./core", "./ripemd160", "./hmac"], n) : n((void 0).CryptoJS),
        cc._RF.pop()
    }
    , {
        "./core": "core",
        "./hmac": "hmac",
        "./ripemd160": "ripemd160"
    }],
    "hmac-sha1": [function(e, t, o) {
        "use strict";
        var n;
        cc._RF.push(t, "bf852Y8WqRE5pyAFG9m9mHM", "hmac-sha1"),
        n = function(e) {
            return e.HmacSHA1
        }
        ,
        "object" == typeof o ? t.exports = o = n(e("./core"), e("./sha1"), e("./hmac")) : "function" == typeof define && define.amd ? define(["./core", "./sha1", "./hmac"], n) : n((void 0).CryptoJS),
        cc._RF.pop()
    }
    , {
        "./core": "core",
        "./hmac": "hmac",
        "./sha1": "sha1"
    }],
    "hmac-sha224": [function(e, t, o) {
        "use strict";
        var n;
        cc._RF.push(t, "4d3ef0QhWFG64KeDRXXIAe8", "hmac-sha224"),
        n = function(e) {
            return e.HmacSHA224
        }
        ,
        "object" == typeof o ? t.exports = o = n(e("./core"), e("./sha256"), e("./sha224"), e("./hmac")) : "function" == typeof define && define.amd ? define(["./core", "./sha256", "./sha224", "./hmac"], n) : n((void 0).CryptoJS),
        cc._RF.pop()
    }
    , {
        "./core": "core",
        "./hmac": "hmac",
        "./sha224": "sha224",
        "./sha256": "sha256"
    }],
    "hmac-sha256": [function(e, t, o) {
        "use strict";
        var n;
        cc._RF.push(t, "722d6oiAApMr4agtjhKqDgU", "hmac-sha256"),
        n = function(e) {
            return e.HmacSHA256
        }
        ,
        "object" == typeof o ? t.exports = o = n(e("./core"), e("./sha256"), e("./hmac")) : "function" == typeof define && define.amd ? define(["./core", "./sha256", "./hmac"], n) : n((void 0).CryptoJS),
        cc._RF.pop()
    }
    , {
        "./core": "core",
        "./hmac": "hmac",
        "./sha256": "sha256"
    }],
    "hmac-sha384": [function(e, t, o) {
        "use strict";
        var n;
        cc._RF.push(t, "4ddd9jUUAJMRp8VhJl3irvA", "hmac-sha384"),
        n = function(e) {
            return e.HmacSHA384
        }
        ,
        "object" == typeof o ? t.exports = o = n(e("./core"), e("./x64-core"), e("./sha512"), e("./sha384"), e("./hmac")) : "function" == typeof define && define.amd ? define(["./core", "./x64-core", "./sha512", "./sha384", "./hmac"], n) : n((void 0).CryptoJS),
        cc._RF.pop()
    }
    , {
        "./core": "core",
        "./hmac": "hmac",
        "./sha384": "sha384",
        "./sha512": "sha512",
        "./x64-core": "x64-core"
    }],
    "hmac-sha3": [function(e, t, o) {
        "use strict";
        var n;
        cc._RF.push(t, "1a534EFeVNLvI3qn7QBm0lC", "hmac-sha3"),
        n = function(e) {
            return e.HmacSHA3
        }
        ,
        "object" == typeof o ? t.exports = o = n(e("./core"), e("./x64-core"), e("./sha3"), e("./hmac")) : "function" == typeof define && define.amd ? define(["./core", "./x64-core", "./sha3", "./hmac"], n) : n((void 0).CryptoJS),
        cc._RF.pop()
    }
    , {
        "./core": "core",
        "./hmac": "hmac",
        "./sha3": "sha3",
        "./x64-core": "x64-core"
    }],
    "hmac-sha512": [function(e, t, o) {
        "use strict";
        var n;
        cc._RF.push(t, "0f002mjg7NE/Lw1T2HsvA+Y", "hmac-sha512"),
        n = function(e) {
            return e.HmacSHA512
        }
        ,
        "object" == typeof o ? t.exports = o = n(e("./core"), e("./x64-core"), e("./sha512"), e("./hmac")) : "function" == typeof define && define.amd ? define(["./core", "./x64-core", "./sha512", "./hmac"], n) : n((void 0).CryptoJS),
        cc._RF.pop()
    }
    , {
        "./core": "core",
        "./hmac": "hmac",
        "./sha512": "sha512",
        "./x64-core": "x64-core"
    }],
    hmac: [function(e, t, o) {
        "use strict";
        var n;
        cc._RF.push(t, "f6c22cyoiJMYbE7Kacwtxf5", "hmac"),
        n = function(e) {
            var t, o, n;
            o = (t = e).lib.Base,
            n = t.enc.Utf8,
            t.algo.HMAC = o.extend({
                init: function(e, t) {
                    e = this._hasher = new e.init,
                    "string" == typeof t && (t = n.parse(t));
                    var o = e.blockSize
                      , i = 4 * o;
                    t.sigBytes > i && (t = e.finalize(t)),
                    t.clamp();
                    for (var r = this._oKey = t.clone(), a = this._iKey = t.clone(), s = r.words, c = a.words, l = 0; l < o; l++)
                        s[l] ^= 1549556828,
                        c[l] ^= 909522486;
                    r.sigBytes = a.sigBytes = i,
                    this.reset()
                },
                reset: function() {
                    var e = this._hasher;
                    e.reset(),
                    e.update(this._iKey)
                },
                update: function(e) {
                    return this._hasher.update(e),
                    this
                },
                finalize: function(e) {
                    var t = this._hasher
                      , o = t.finalize(e);
                    return t.reset(),
                    t.finalize(this._oKey.clone().concat(o))
                }
            })
        }
        ,
        "object" == typeof o ? t.exports = o = n(e("./core")) : "function" == typeof define && define.amd ? define(["./core"], n) : n((void 0).CryptoJS),
        cc._RF.pop()
    }
    , {
        "./core": "core"
    }],
    index: [function(e, t, o) {
        "use strict";
        var n;
        cc._RF.push(t, "c078cqwugpOsoMRfzxvExZg", "index"),
        n = function(e) {
            return e
        }
        ,
        "object" == typeof o ? t.exports = o = n(e("./core"), e("./x64-core"), e("./lib-typedarrays"), e("./enc-utf16"), e("./enc-base64"), e("./md5"), e("./sha1"), e("./sha256"), e("./sha224"), e("./sha512"), e("./sha384"), e("./sha3"), e("./ripemd160"), e("./hmac"), e("./pbkdf2"), e("./evpkdf"), e("./cipher-core"), e("./mode-cfb"), e("./mode-ctr"), e("./mode-ctr-gladman"), e("./mode-ofb"), e("./mode-ecb"), e("./pad-ansix923"), e("./pad-iso10126"), e("./pad-iso97971"), e("./pad-zeropadding"), e("./pad-nopadding"), e("./format-hex"), e("./aes"), e("./tripledes"), e("./rc4"), e("./rabbit"), e("./rabbit-legacy")) : "function" == typeof define && define.amd ? define(["./core", "./x64-core", "./lib-typedarrays", "./enc-utf16", "./enc-base64", "./md5", "./sha1", "./sha256", "./sha224", "./sha512", "./sha384", "./sha3", "./ripemd160", "./hmac", "./pbkdf2", "./evpkdf", "./cipher-core", "./mode-cfb", "./mode-ctr", "./mode-ctr-gladman", "./mode-ofb", "./mode-ecb", "./pad-ansix923", "./pad-iso10126", "./pad-iso97971", "./pad-zeropadding", "./pad-nopadding", "./format-hex", "./aes", "./tripledes", "./rc4", "./rabbit", "./rabbit-legacy"], n) : (void 0).CryptoJS = n((void 0).CryptoJS),
        cc._RF.pop()
    }
    , {
        "./aes": "aes",
        "./cipher-core": "cipher-core",
        "./core": "core",
        "./enc-base64": "enc-base64",
        "./enc-utf16": "enc-utf16",
        "./evpkdf": "evpkdf",
        "./format-hex": "format-hex",
        "./hmac": "hmac",
        "./lib-typedarrays": "lib-typedarrays",
        "./md5": "md5",
        "./mode-cfb": "mode-cfb",
        "./mode-ctr": "mode-ctr",
        "./mode-ctr-gladman": "mode-ctr-gladman",
        "./mode-ecb": "mode-ecb",
        "./mode-ofb": "mode-ofb",
        "./pad-ansix923": "pad-ansix923",
        "./pad-iso10126": "pad-iso10126",
        "./pad-iso97971": "pad-iso97971",
        "./pad-nopadding": "pad-nopadding",
        "./pad-zeropadding": "pad-zeropadding",
        "./pbkdf2": "pbkdf2",
        "./rabbit": "rabbit",
        "./rabbit-legacy": "rabbit-legacy",
        "./rc4": "rc4",
        "./ripemd160": "ripemd160",
        "./sha1": "sha1",
        "./sha224": "sha224",
        "./sha256": "sha256",
        "./sha3": "sha3",
        "./sha384": "sha384",
        "./sha512": "sha512",
        "./tripledes": "tripledes",
        "./x64-core": "x64-core"
    }],
    "lib-typedarrays": [function(e, t, o) {
        "use strict";
        var n;
        cc._RF.push(t, "afc22vSEDdC8aK6iogLo4QL", "lib-typedarrays"),
        n = function(e) {
            return function() {
                if ("function" == typeof ArrayBuffer) {
                    var t = e.lib.WordArray
                      , o = t.init;
                    (t.init = function(e) {
                        if (e instanceof ArrayBuffer && (e = new Uint8Array(e)),
                        (e instanceof Int8Array || "undefined" != typeof Uint8ClampedArray && e instanceof Uint8ClampedArray || e instanceof Int16Array || e instanceof Uint16Array || e instanceof Int32Array || e instanceof Uint32Array || e instanceof Float32Array || e instanceof Float64Array) && (e = new Uint8Array(e.buffer,e.byteOffset,e.byteLength)),
                        e instanceof Uint8Array) {
                            for (var t = e.byteLength, n = [], i = 0; i < t; i++)
                                n[i >>> 2] |= e[i] << 24 - i % 4 * 8;
                            o.call(this, n, t)
                        } else
                            o.apply(this, arguments)
                    }
                    ).prototype = t
                }
            }(),
            e.lib.WordArray
        }
        ,
        "object" == typeof o ? t.exports = o = n(e("./core")) : "function" == typeof define && define.amd ? define(["./core"], n) : n((void 0).CryptoJS),
        cc._RF.pop()
    }
    , {
        "./core": "core"
    }],
    md5: [function(e, t, o) {
        "use strict";
        var n;
        cc._RF.push(t, "50204ZXJshB9bSltwjujVuZ", "md5"),
        n = function(e) {
            return function(t) {
                var o = e
                  , n = o.lib
                  , i = n.WordArray
                  , r = n.Hasher
                  , a = o.algo
                  , s = [];
                (function() {
                    for (var e = 0; e < 64; e++)
                        s[e] = 4294967296 * t.abs(t.sin(e + 1)) | 0
                }
                )();
                var c = a.MD5 = r.extend({
                    _doReset: function() {
                        this._hash = new i.init([1732584193, 4023233417, 2562383102, 271733878])
                    },
                    _doProcessBlock: function(e, t) {
                        for (var o = 0; o < 16; o++) {
                            var n = t + o
                              , i = e[n];
                            e[n] = 16711935 & (i << 8 | i >>> 24) | 4278255360 & (i << 24 | i >>> 8)
                        }
                        var r = this._hash.words
                          , a = e[t + 0]
                          , c = e[t + 1]
                          , u = e[t + 2]
                          , p = e[t + 3]
                          , g = e[t + 4]
                          , _ = e[t + 5]
                          , y = e[t + 6]
                          , m = e[t + 7]
                          , v = e[t + 8]
                          , b = e[t + 9]
                          , C = e[t + 10]
                          , M = e[t + 11]
                          , S = e[t + 12]
                          , w = e[t + 13]
                          , N = e[t + 14]
                          , B = e[t + 15]
                          , P = r[0]
                          , k = r[1]
                          , R = r[2]
                          , T = r[3];
                        P = l(P, k, R, T, a, 7, s[0]),
                        T = l(T, P, k, R, c, 12, s[1]),
                        R = l(R, T, P, k, u, 17, s[2]),
                        k = l(k, R, T, P, p, 22, s[3]),
                        P = l(P, k, R, T, g, 7, s[4]),
                        T = l(T, P, k, R, _, 12, s[5]),
                        R = l(R, T, P, k, y, 17, s[6]),
                        k = l(k, R, T, P, m, 22, s[7]),
                        P = l(P, k, R, T, v, 7, s[8]),
                        T = l(T, P, k, R, b, 12, s[9]),
                        R = l(R, T, P, k, C, 17, s[10]),
                        k = l(k, R, T, P, M, 22, s[11]),
                        P = l(P, k, R, T, S, 7, s[12]),
                        T = l(T, P, k, R, w, 12, s[13]),
                        R = l(R, T, P, k, N, 17, s[14]),
                        P = f(P, k = l(k, R, T, P, B, 22, s[15]), R, T, c, 5, s[16]),
                        T = f(T, P, k, R, y, 9, s[17]),
                        R = f(R, T, P, k, M, 14, s[18]),
                        k = f(k, R, T, P, a, 20, s[19]),
                        P = f(P, k, R, T, _, 5, s[20]),
                        T = f(T, P, k, R, C, 9, s[21]),
                        R = f(R, T, P, k, B, 14, s[22]),
                        k = f(k, R, T, P, g, 20, s[23]),
                        P = f(P, k, R, T, b, 5, s[24]),
                        T = f(T, P, k, R, N, 9, s[25]),
                        R = f(R, T, P, k, p, 14, s[26]),
                        k = f(k, R, T, P, v, 20, s[27]),
                        P = f(P, k, R, T, w, 5, s[28]),
                        T = f(T, P, k, R, u, 9, s[29]),
                        R = f(R, T, P, k, m, 14, s[30]),
                        P = h(P, k = f(k, R, T, P, S, 20, s[31]), R, T, _, 4, s[32]),
                        T = h(T, P, k, R, v, 11, s[33]),
                        R = h(R, T, P, k, M, 16, s[34]),
                        k = h(k, R, T, P, N, 23, s[35]),
                        P = h(P, k, R, T, c, 4, s[36]),
                        T = h(T, P, k, R, g, 11, s[37]),
                        R = h(R, T, P, k, m, 16, s[38]),
                        k = h(k, R, T, P, C, 23, s[39]),
                        P = h(P, k, R, T, w, 4, s[40]),
                        T = h(T, P, k, R, a, 11, s[41]),
                        R = h(R, T, P, k, p, 16, s[42]),
                        k = h(k, R, T, P, y, 23, s[43]),
                        P = h(P, k, R, T, b, 4, s[44]),
                        T = h(T, P, k, R, S, 11, s[45]),
                        R = h(R, T, P, k, B, 16, s[46]),
                        P = d(P, k = h(k, R, T, P, u, 23, s[47]), R, T, a, 6, s[48]),
                        T = d(T, P, k, R, m, 10, s[49]),
                        R = d(R, T, P, k, N, 15, s[50]),
                        k = d(k, R, T, P, _, 21, s[51]),
                        P = d(P, k, R, T, S, 6, s[52]),
                        T = d(T, P, k, R, p, 10, s[53]),
                        R = d(R, T, P, k, C, 15, s[54]),
                        k = d(k, R, T, P, c, 21, s[55]),
                        P = d(P, k, R, T, v, 6, s[56]),
                        T = d(T, P, k, R, B, 10, s[57]),
                        R = d(R, T, P, k, y, 15, s[58]),
                        k = d(k, R, T, P, w, 21, s[59]),
                        P = d(P, k, R, T, g, 6, s[60]),
                        T = d(T, P, k, R, M, 10, s[61]),
                        R = d(R, T, P, k, u, 15, s[62]),
                        k = d(k, R, T, P, b, 21, s[63]),
                        r[0] = r[0] + P | 0,
                        r[1] = r[1] + k | 0,
                        r[2] = r[2] + R | 0,
                        r[3] = r[3] + T | 0
                    },
                    _doFinalize: function() {
                        var e = this._data
                          , o = e.words
                          , n = 8 * this._nDataBytes
                          , i = 8 * e.sigBytes;
                        o[i >>> 5] |= 128 << 24 - i % 32;
                        var r = t.floor(n / 4294967296)
                          , a = n;
                        o[15 + (i + 64 >>> 9 << 4)] = 16711935 & (r << 8 | r >>> 24) | 4278255360 & (r << 24 | r >>> 8),
                        o[14 + (i + 64 >>> 9 << 4)] = 16711935 & (a << 8 | a >>> 24) | 4278255360 & (a << 24 | a >>> 8),
                        e.sigBytes = 4 * (o.length + 1),
                        this._process();
                        for (var s = this._hash, c = s.words, l = 0; l < 4; l++) {
                            var f = c[l];
                            c[l] = 16711935 & (f << 8 | f >>> 24) | 4278255360 & (f << 24 | f >>> 8)
                        }
                        return s
                    },
                    clone: function() {
                        var e = r.clone.call(this);
                        return e._hash = this._hash.clone(),
                        e
                    }
                });
                function l(e, t, o, n, i, r, a) {
                    var s = e + (t & o | ~t & n) + i + a;
                    return (s << r | s >>> 32 - r) + t
                }
                function f(e, t, o, n, i, r, a) {
                    var s = e + (t & n | o & ~n) + i + a;
                    return (s << r | s >>> 32 - r) + t
                }
                function h(e, t, o, n, i, r, a) {
                    var s = e + (t ^ o ^ n) + i + a;
                    return (s << r | s >>> 32 - r) + t
                }
                function d(e, t, o, n, i, r, a) {
                    var s = e + (o ^ (t | ~n)) + i + a;
                    return (s << r | s >>> 32 - r) + t
                }
                o.MD5 = r._createHelper(c),
                o.HmacMD5 = r._createHmacHelper(c)
            }(Math),
            e.MD5
        }
        ,
        "object" == typeof o ? t.exports = o = n(e("./core")) : "function" == typeof define && define.amd ? define(["./core"], n) : n((void 0).CryptoJS),
        cc._RF.pop()
    }
    , {
        "./core": "core"
    }],
    "mode-cfb": [function(e, t, o) {
        "use strict";
        var n;
        cc._RF.push(t, "a4b34aqLWBK2b2lorfyua/Q", "mode-cfb"),
        n = function(e) {
            return e.mode.CFB = function() {
                var t = e.lib.BlockCipherMode.extend();
                function o(e, t, o, n) {
                    var i = this._iv;
                    if (i) {
                        var r = i.slice(0);
                        this._iv = void 0
                    } else
                        r = this._prevBlock;
                    n.encryptBlock(r, 0);
                    for (var a = 0; a < o; a++)
                        e[t + a] ^= r[a]
                }
                return t.Encryptor = t.extend({
                    processBlock: function(e, t) {
                        var n = this._cipher
                          , i = n.blockSize;
                        o.call(this, e, t, i, n),
                        this._prevBlock = e.slice(t, t + i)
                    }
                }),
                t.Decryptor = t.extend({
                    processBlock: function(e, t) {
                        var n = this._cipher
                          , i = n.blockSize
                          , r = e.slice(t, t + i);
                        o.call(this, e, t, i, n),
                        this._prevBlock = r
                    }
                }),
                t
            }(),
            e.mode.CFB
        }
        ,
        "object" == typeof o ? t.exports = o = n(e("./core"), e("./cipher-core")) : "function" == typeof define && define.amd ? define(["./core", "./cipher-core"], n) : n((void 0).CryptoJS),
        cc._RF.pop()
    }
    , {
        "./cipher-core": "cipher-core",
        "./core": "core"
    }],
    "mode-ctr-gladman": [function(e, t, o) {
        "use strict";
        var n;
        cc._RF.push(t, "6b39e1pUz1LX4ZYPqEDNtrt", "mode-ctr-gladman"),
        n = function(e) {
            return e.mode.CTRGladman = function() {
                var t = e.lib.BlockCipherMode.extend();
                function o(e) {
                    if (255 == (e >> 24 & 255)) {
                        var t = e >> 16 & 255
                          , o = e >> 8 & 255
                          , n = 255 & e;
                        255 === t ? (t = 0,
                        255 === o ? (o = 0,
                        255 === n ? n = 0 : ++n) : ++o) : ++t,
                        e = 0,
                        e += t << 16,
                        e += o << 8,
                        e += n
                    } else
                        e += 1 << 24;
                    return e
                }
                function n(e) {
                    return 0 === (e[0] = o(e[0])) && (e[1] = o(e[1])),
                    e
                }
                var i = t.Encryptor = t.extend({
                    processBlock: function(e, t) {
                        var o = this._cipher
                          , i = o.blockSize
                          , r = this._iv
                          , a = this._counter;
                        r && (a = this._counter = r.slice(0),
                        this._iv = void 0),
                        n(a);
                        var s = a.slice(0);
                        o.encryptBlock(s, 0);
                        for (var c = 0; c < i; c++)
                            e[t + c] ^= s[c]
                    }
                });
                return t.Decryptor = i,
                t
            }(),
            e.mode.CTRGladman
        }
        ,
        "object" == typeof o ? t.exports = o = n(e("./core"), e("./cipher-core")) : "function" == typeof define && define.amd ? define(["./core", "./cipher-core"], n) : n((void 0).CryptoJS),
        cc._RF.pop()
    }
    , {
        "./cipher-core": "cipher-core",
        "./core": "core"
    }],
    "mode-ctr": [function(e, t, o) {
        "use strict";
        var n;
        cc._RF.push(t, "9757f4ZVtxL741rKxFsf+8x", "mode-ctr"),
        n = function(e) {
            var t, o;
            return e.mode.CTR = (o = (t = e.lib.BlockCipherMode.extend()).Encryptor = t.extend({
                processBlock: function(e, t) {
                    var o = this._cipher
                      , n = o.blockSize
                      , i = this._iv
                      , r = this._counter;
                    i && (r = this._counter = i.slice(0),
                    this._iv = void 0);
                    var a = r.slice(0);
                    o.encryptBlock(a, 0),
                    r[n - 1] = r[n - 1] + 1 | 0;
                    for (var s = 0; s < n; s++)
                        e[t + s] ^= a[s]
                }
            }),
            t.Decryptor = o,
            t),
            e.mode.CTR
        }
        ,
        "object" == typeof o ? t.exports = o = n(e("./core"), e("./cipher-core")) : "function" == typeof define && define.amd ? define(["./core", "./cipher-core"], n) : n((void 0).CryptoJS),
        cc._RF.pop()
    }
    , {
        "./cipher-core": "cipher-core",
        "./core": "core"
    }],
    "mode-ecb": [function(e, t, o) {
        "use strict";
        var n;
        cc._RF.push(t, "9faffiNUQdFkKYNHz4o/omh", "mode-ecb"),
        n = function(e) {
            var t;
            return e.mode.ECB = ((t = e.lib.BlockCipherMode.extend()).Encryptor = t.extend({
                processBlock: function(e, t) {
                    this._cipher.encryptBlock(e, t)
                }
            }),
            t.Decryptor = t.extend({
                processBlock: function(e, t) {
                    this._cipher.decryptBlock(e, t)
                }
            }),
            t),
            e.mode.ECB
        }
        ,
        "object" == typeof o ? t.exports = o = n(e("./core"), e("./cipher-core")) : "function" == typeof define && define.amd ? define(["./core", "./cipher-core"], n) : n((void 0).CryptoJS),
        cc._RF.pop()
    }
    , {
        "./cipher-core": "cipher-core",
        "./core": "core"
    }],
    "mode-ofb": [function(e, t, o) {
        "use strict";
        var n;
        cc._RF.push(t, "caf7eyDn49C44GUvrofOFdb", "mode-ofb"),
        n = function(e) {
            var t, o;
            return e.mode.OFB = (o = (t = e.lib.BlockCipherMode.extend()).Encryptor = t.extend({
                processBlock: function(e, t) {
                    var o = this._cipher
                      , n = o.blockSize
                      , i = this._iv
                      , r = this._keystream;
                    i && (r = this._keystream = i.slice(0),
                    this._iv = void 0),
                    o.encryptBlock(r, 0);
                    for (var a = 0; a < n; a++)
                        e[t + a] ^= r[a]
                }
            }),
            t.Decryptor = o,
            t),
            e.mode.OFB
        }
        ,
        "object" == typeof o ? t.exports = o = n(e("./core"), e("./cipher-core")) : "function" == typeof define && define.amd ? define(["./core", "./cipher-core"], n) : n((void 0).CryptoJS),
        cc._RF.pop()
    }
    , {
        "./cipher-core": "cipher-core",
        "./core": "core"
    }],
    "pad-ansix923": [function(e, t, o) {
        "use strict";
        var n;
        cc._RF.push(t, "bc552a8YcpK8aBvKIYqts71", "pad-ansix923"),
        n = function(e) {
            return e.pad.AnsiX923 = {
                pad: function(e, t) {
                    var o = e.sigBytes
                      , n = 4 * t
                      , i = n - o % n
                      , r = o + i - 1;
                    e.clamp(),
                    e.words[r >>> 2] |= i << 24 - r % 4 * 8,
                    e.sigBytes += i
                },
                unpad: function(e) {
                    var t = 255 & e.words[e.sigBytes - 1 >>> 2];
                    e.sigBytes -= t
                }
            },
            e.pad.Ansix923
        }
        ,
        "object" == typeof o ? t.exports = o = n(e("./core"), e("./cipher-core")) : "function" == typeof define && define.amd ? define(["./core", "./cipher-core"], n) : n((void 0).CryptoJS),
        cc._RF.pop()
    }
    , {
        "./cipher-core": "cipher-core",
        "./core": "core"
    }],
    "pad-iso10126": [function(e, t, o) {
        "use strict";
        var n;
        cc._RF.push(t, "f8ead33oShJ/IyfYZEVJp3t", "pad-iso10126"),
        n = function(e) {
            return e.pad.Iso10126 = {
                pad: function(t, o) {
                    var n = 4 * o
                      , i = n - t.sigBytes % n;
                    t.concat(e.lib.WordArray.random(i - 1)).concat(e.lib.WordArray.create([i << 24], 1))
                },
                unpad: function(e) {
                    var t = 255 & e.words[e.sigBytes - 1 >>> 2];
                    e.sigBytes -= t
                }
            },
            e.pad.Iso10126
        }
        ,
        "object" == typeof o ? t.exports = o = n(e("./core"), e("./cipher-core")) : "function" == typeof define && define.amd ? define(["./core", "./cipher-core"], n) : n((void 0).CryptoJS),
        cc._RF.pop()
    }
    , {
        "./cipher-core": "cipher-core",
        "./core": "core"
    }],
    "pad-iso97971": [function(e, t, o) {
        "use strict";
        var n;
        cc._RF.push(t, "212daZAEB5G14g0yi/p6c2D", "pad-iso97971"),
        n = function(e) {
            return e.pad.Iso97971 = {
                pad: function(t, o) {
                    t.concat(e.lib.WordArray.create([2147483648], 1)),
                    e.pad.ZeroPadding.pad(t, o)
                },
                unpad: function(t) {
                    e.pad.ZeroPadding.unpad(t),
                    t.sigBytes--
                }
            },
            e.pad.Iso97971
        }
        ,
        "object" == typeof o ? t.exports = o = n(e("./core"), e("./cipher-core")) : "function" == typeof define && define.amd ? define(["./core", "./cipher-core"], n) : n((void 0).CryptoJS),
        cc._RF.pop()
    }
    , {
        "./cipher-core": "cipher-core",
        "./core": "core"
    }],
    "pad-nopadding": [function(e, t, o) {
        "use strict";
        var n;
        cc._RF.push(t, "36d3bq/NdZK/KsZu3Sehk8x", "pad-nopadding"),
        n = function(e) {
            return e.pad.NoPadding = {
                pad: function() {},
                unpad: function() {}
            },
            e.pad.NoPadding
        }
        ,
        "object" == typeof o ? t.exports = o = n(e("./core"), e("./cipher-core")) : "function" == typeof define && define.amd ? define(["./core", "./cipher-core"], n) : n((void 0).CryptoJS),
        cc._RF.pop()
    }
    , {
        "./cipher-core": "cipher-core",
        "./core": "core"
    }],
    "pad-pkcs7": [function(e, t, o) {
        "use strict";
        var n;
        cc._RF.push(t, "a0326ziym5Iqro1TtSHsy0s", "pad-pkcs7"),
        n = function(e) {
            return e.pad.Pkcs7
        }
        ,
        "object" == typeof o ? t.exports = o = n(e("./core"), e("./cipher-core")) : "function" == typeof define && define.amd ? define(["./core", "./cipher-core"], n) : n((void 0).CryptoJS),
        cc._RF.pop()
    }
    , {
        "./cipher-core": "cipher-core",
        "./core": "core"
    }],
    "pad-zeropadding": [function(e, t, o) {
        "use strict";
        var n;
        cc._RF.push(t, "904a7Gp24xICr4AR7mmMtQF", "pad-zeropadding"),
        n = function(e) {
            return e.pad.ZeroPadding = {
                pad: function(e, t) {
                    var o = 4 * t;
                    e.clamp(),
                    e.sigBytes += o - (e.sigBytes % o || o)
                },
                unpad: function(e) {
                    for (var t = e.words, o = e.sigBytes - 1; !(t[o >>> 2] >>> 24 - o % 4 * 8 & 255); )
                        o--;
                    e.sigBytes = o + 1
                }
            },
            e.pad.ZeroPadding
        }
        ,
        "object" == typeof o ? t.exports = o = n(e("./core"), e("./cipher-core")) : "function" == typeof define && define.amd ? define(["./core", "./cipher-core"], n) : n((void 0).CryptoJS),
        cc._RF.pop()
    }
    , {
        "./cipher-core": "cipher-core",
        "./core": "core"
    }],
    pbkdf2: [function(e, t, o) {
        "use strict";
        var n;
        cc._RF.push(t, "d7d4d1W/ZVMYp8mKP/qZ5/d", "pbkdf2"),
        n = function(e) {
            var t, o, n, i, r, a, s, c;
            return n = (o = (t = e).lib).Base,
            i = o.WordArray,
            a = (r = t.algo).SHA1,
            s = r.HMAC,
            c = r.PBKDF2 = n.extend({
                cfg: n.extend({
                    keySize: 4,
                    hasher: a,
                    iterations: 1
                }),
                init: function(e) {
                    this.cfg = this.cfg.extend(e)
                },
                compute: function(e, t) {
                    for (var o = this.cfg, n = s.create(o.hasher, e), r = i.create(), a = i.create([1]), c = r.words, l = a.words, f = o.keySize, h = o.iterations; c.length < f; ) {
                        var d = n.update(t).finalize(a);
                        n.reset();
                        for (var u = d.words, p = u.length, g = d, _ = 1; _ < h; _++) {
                            g = n.finalize(g),
                            n.reset();
                            for (var y = g.words, m = 0; m < p; m++)
                                u[m] ^= y[m]
                        }
                        r.concat(d),
                        l[0]++
                    }
                    return r.sigBytes = 4 * f,
                    r
                }
            }),
            t.PBKDF2 = function(e, t, o) {
                return c.create(o).compute(e, t)
            }
            ,
            e.PBKDF2
        }
        ,
        "object" == typeof o ? t.exports = o = n(e("./core"), e("./sha1"), e("./hmac")) : "function" == typeof define && define.amd ? define(["./core", "./sha1", "./hmac"], n) : n((void 0).CryptoJS),
        cc._RF.pop()
    }
    , {
        "./core": "core",
        "./hmac": "hmac",
        "./sha1": "sha1"
    }],
    "rabbit-legacy": [function(e, t, o) {
        "use strict";
        var n;
        cc._RF.push(t, "7f5d4yG/HVE064jXqmYoa/+", "rabbit-legacy"),
        n = function(e) {
            return function() {
                var t = e
                  , o = t.lib.StreamCipher
                  , n = t.algo
                  , i = []
                  , r = []
                  , a = []
                  , s = n.RabbitLegacy = o.extend({
                    _doReset: function() {
                        var e = this._key.words
                          , t = this.cfg.iv
                          , o = this._X = [e[0], e[3] << 16 | e[2] >>> 16, e[1], e[0] << 16 | e[3] >>> 16, e[2], e[1] << 16 | e[0] >>> 16, e[3], e[2] << 16 | e[1] >>> 16]
                          , n = this._C = [e[2] << 16 | e[2] >>> 16, 4294901760 & e[0] | 65535 & e[1], e[3] << 16 | e[3] >>> 16, 4294901760 & e[1] | 65535 & e[2], e[0] << 16 | e[0] >>> 16, 4294901760 & e[2] | 65535 & e[3], e[1] << 16 | e[1] >>> 16, 4294901760 & e[3] | 65535 & e[0]];
                        this._b = 0;
                        for (var i = 0; i < 4; i++)
                            c.call(this);
                        for (i = 0; i < 8; i++)
                            n[i] ^= o[i + 4 & 7];
                        if (t) {
                            var r = t.words
                              , a = r[0]
                              , s = r[1]
                              , l = 16711935 & (a << 8 | a >>> 24) | 4278255360 & (a << 24 | a >>> 8)
                              , f = 16711935 & (s << 8 | s >>> 24) | 4278255360 & (s << 24 | s >>> 8)
                              , h = l >>> 16 | 4294901760 & f
                              , d = f << 16 | 65535 & l;
                            for (n[0] ^= l,
                            n[1] ^= h,
                            n[2] ^= f,
                            n[3] ^= d,
                            n[4] ^= l,
                            n[5] ^= h,
                            n[6] ^= f,
                            n[7] ^= d,
                            i = 0; i < 4; i++)
                                c.call(this)
                        }
                    },
                    _doProcessBlock: function(e, t) {
                        var o = this._X;
                        c.call(this),
                        i[0] = o[0] ^ o[5] >>> 16 ^ o[3] << 16,
                        i[1] = o[2] ^ o[7] >>> 16 ^ o[5] << 16,
                        i[2] = o[4] ^ o[1] >>> 16 ^ o[7] << 16,
                        i[3] = o[6] ^ o[3] >>> 16 ^ o[1] << 16;
                        for (var n = 0; n < 4; n++)
                            i[n] = 16711935 & (i[n] << 8 | i[n] >>> 24) | 4278255360 & (i[n] << 24 | i[n] >>> 8),
                            e[t + n] ^= i[n]
                    },
                    blockSize: 4,
                    ivSize: 2
                });
                function c() {
                    for (var e = this._X, t = this._C, o = 0; o < 8; o++)
                        r[o] = t[o];
                    for (t[0] = t[0] + 1295307597 + this._b | 0,
                    t[1] = t[1] + 3545052371 + (t[0] >>> 0 < r[0] >>> 0 ? 1 : 0) | 0,
                    t[2] = t[2] + 886263092 + (t[1] >>> 0 < r[1] >>> 0 ? 1 : 0) | 0,
                    t[3] = t[3] + 1295307597 + (t[2] >>> 0 < r[2] >>> 0 ? 1 : 0) | 0,
                    t[4] = t[4] + 3545052371 + (t[3] >>> 0 < r[3] >>> 0 ? 1 : 0) | 0,
                    t[5] = t[5] + 886263092 + (t[4] >>> 0 < r[4] >>> 0 ? 1 : 0) | 0,
                    t[6] = t[6] + 1295307597 + (t[5] >>> 0 < r[5] >>> 0 ? 1 : 0) | 0,
                    t[7] = t[7] + 3545052371 + (t[6] >>> 0 < r[6] >>> 0 ? 1 : 0) | 0,
                    this._b = t[7] >>> 0 < r[7] >>> 0 ? 1 : 0,
                    o = 0; o < 8; o++) {
                        var n = e[o] + t[o]
                          , i = 65535 & n
                          , s = n >>> 16
                          , c = ((i * i >>> 17) + i * s >>> 15) + s * s
                          , l = ((4294901760 & n) * n | 0) + ((65535 & n) * n | 0);
                        a[o] = c ^ l
                    }
                    e[0] = a[0] + (a[7] << 16 | a[7] >>> 16) + (a[6] << 16 | a[6] >>> 16) | 0,
                    e[1] = a[1] + (a[0] << 8 | a[0] >>> 24) + a[7] | 0,
                    e[2] = a[2] + (a[1] << 16 | a[1] >>> 16) + (a[0] << 16 | a[0] >>> 16) | 0,
                    e[3] = a[3] + (a[2] << 8 | a[2] >>> 24) + a[1] | 0,
                    e[4] = a[4] + (a[3] << 16 | a[3] >>> 16) + (a[2] << 16 | a[2] >>> 16) | 0,
                    e[5] = a[5] + (a[4] << 8 | a[4] >>> 24) + a[3] | 0,
                    e[6] = a[6] + (a[5] << 16 | a[5] >>> 16) + (a[4] << 16 | a[4] >>> 16) | 0,
                    e[7] = a[7] + (a[6] << 8 | a[6] >>> 24) + a[5] | 0
                }
                t.RabbitLegacy = o._createHelper(s)
            }(),
            e.RabbitLegacy
        }
        ,
        "object" == typeof o ? t.exports = o = n(e("./core"), e("./enc-base64"), e("./md5"), e("./evpkdf"), e("./cipher-core")) : "function" == typeof define && define.amd ? define(["./core", "./enc-base64", "./md5", "./evpkdf", "./cipher-core"], n) : n((void 0).CryptoJS),
        cc._RF.pop()
    }
    , {
        "./cipher-core": "cipher-core",
        "./core": "core",
        "./enc-base64": "enc-base64",
        "./evpkdf": "evpkdf",
        "./md5": "md5"
    }],
    rabbit: [function(e, t, o) {
        "use strict";
        var n;
        cc._RF.push(t, "a75c6fYMilCjZOgsMB7EGSz", "rabbit"),
        n = function(e) {
            return function() {
                var t = e
                  , o = t.lib.StreamCipher
                  , n = t.algo
                  , i = []
                  , r = []
                  , a = []
                  , s = n.Rabbit = o.extend({
                    _doReset: function() {
                        for (var e = this._key.words, t = this.cfg.iv, o = 0; o < 4; o++)
                            e[o] = 16711935 & (e[o] << 8 | e[o] >>> 24) | 4278255360 & (e[o] << 24 | e[o] >>> 8);
                        var n = this._X = [e[0], e[3] << 16 | e[2] >>> 16, e[1], e[0] << 16 | e[3] >>> 16, e[2], e[1] << 16 | e[0] >>> 16, e[3], e[2] << 16 | e[1] >>> 16]
                          , i = this._C = [e[2] << 16 | e[2] >>> 16, 4294901760 & e[0] | 65535 & e[1], e[3] << 16 | e[3] >>> 16, 4294901760 & e[1] | 65535 & e[2], e[0] << 16 | e[0] >>> 16, 4294901760 & e[2] | 65535 & e[3], e[1] << 16 | e[1] >>> 16, 4294901760 & e[3] | 65535 & e[0]];
                        for (this._b = 0,
                        o = 0; o < 4; o++)
                            c.call(this);
                        for (o = 0; o < 8; o++)
                            i[o] ^= n[o + 4 & 7];
                        if (t) {
                            var r = t.words
                              , a = r[0]
                              , s = r[1]
                              , l = 16711935 & (a << 8 | a >>> 24) | 4278255360 & (a << 24 | a >>> 8)
                              , f = 16711935 & (s << 8 | s >>> 24) | 4278255360 & (s << 24 | s >>> 8)
                              , h = l >>> 16 | 4294901760 & f
                              , d = f << 16 | 65535 & l;
                            for (i[0] ^= l,
                            i[1] ^= h,
                            i[2] ^= f,
                            i[3] ^= d,
                            i[4] ^= l,
                            i[5] ^= h,
                            i[6] ^= f,
                            i[7] ^= d,
                            o = 0; o < 4; o++)
                                c.call(this)
                        }
                    },
                    _doProcessBlock: function(e, t) {
                        var o = this._X;
                        c.call(this),
                        i[0] = o[0] ^ o[5] >>> 16 ^ o[3] << 16,
                        i[1] = o[2] ^ o[7] >>> 16 ^ o[5] << 16,
                        i[2] = o[4] ^ o[1] >>> 16 ^ o[7] << 16,
                        i[3] = o[6] ^ o[3] >>> 16 ^ o[1] << 16;
                        for (var n = 0; n < 4; n++)
                            i[n] = 16711935 & (i[n] << 8 | i[n] >>> 24) | 4278255360 & (i[n] << 24 | i[n] >>> 8),
                            e[t + n] ^= i[n]
                    },
                    blockSize: 4,
                    ivSize: 2
                });
                function c() {
                    for (var e = this._X, t = this._C, o = 0; o < 8; o++)
                        r[o] = t[o];
                    for (t[0] = t[0] + 1295307597 + this._b | 0,
                    t[1] = t[1] + 3545052371 + (t[0] >>> 0 < r[0] >>> 0 ? 1 : 0) | 0,
                    t[2] = t[2] + 886263092 + (t[1] >>> 0 < r[1] >>> 0 ? 1 : 0) | 0,
                    t[3] = t[3] + 1295307597 + (t[2] >>> 0 < r[2] >>> 0 ? 1 : 0) | 0,
                    t[4] = t[4] + 3545052371 + (t[3] >>> 0 < r[3] >>> 0 ? 1 : 0) | 0,
                    t[5] = t[5] + 886263092 + (t[4] >>> 0 < r[4] >>> 0 ? 1 : 0) | 0,
                    t[6] = t[6] + 1295307597 + (t[5] >>> 0 < r[5] >>> 0 ? 1 : 0) | 0,
                    t[7] = t[7] + 3545052371 + (t[6] >>> 0 < r[6] >>> 0 ? 1 : 0) | 0,
                    this._b = t[7] >>> 0 < r[7] >>> 0 ? 1 : 0,
                    o = 0; o < 8; o++) {
                        var n = e[o] + t[o]
                          , i = 65535 & n
                          , s = n >>> 16
                          , c = ((i * i >>> 17) + i * s >>> 15) + s * s
                          , l = ((4294901760 & n) * n | 0) + ((65535 & n) * n | 0);
                        a[o] = c ^ l
                    }
                    e[0] = a[0] + (a[7] << 16 | a[7] >>> 16) + (a[6] << 16 | a[6] >>> 16) | 0,
                    e[1] = a[1] + (a[0] << 8 | a[0] >>> 24) + a[7] | 0,
                    e[2] = a[2] + (a[1] << 16 | a[1] >>> 16) + (a[0] << 16 | a[0] >>> 16) | 0,
                    e[3] = a[3] + (a[2] << 8 | a[2] >>> 24) + a[1] | 0,
                    e[4] = a[4] + (a[3] << 16 | a[3] >>> 16) + (a[2] << 16 | a[2] >>> 16) | 0,
                    e[5] = a[5] + (a[4] << 8 | a[4] >>> 24) + a[3] | 0,
                    e[6] = a[6] + (a[5] << 16 | a[5] >>> 16) + (a[4] << 16 | a[4] >>> 16) | 0,
                    e[7] = a[7] + (a[6] << 8 | a[6] >>> 24) + a[5] | 0
                }
                t.Rabbit = o._createHelper(s)
            }(),
            e.Rabbit
        }
        ,
        "object" == typeof o ? t.exports = o = n(e("./core"), e("./enc-base64"), e("./md5"), e("./evpkdf"), e("./cipher-core")) : "function" == typeof define && define.amd ? define(["./core", "./enc-base64", "./md5", "./evpkdf", "./cipher-core"], n) : n((void 0).CryptoJS),
        cc._RF.pop()
    }
    , {
        "./cipher-core": "cipher-core",
        "./core": "core",
        "./enc-base64": "enc-base64",
        "./evpkdf": "evpkdf",
        "./md5": "md5"
    }],
    rc4: [function(e, t, o) {
        "use strict";
        var n;
        cc._RF.push(t, "33ca9APwudHa5IQ4Pu9Xrh/", "rc4"),
        n = function(e) {
            return function() {
                var t = e
                  , o = t.lib.StreamCipher
                  , n = t.algo
                  , i = n.RC4 = o.extend({
                    _doReset: function() {
                        for (var e = this._key, t = e.words, o = e.sigBytes, n = this._S = [], i = 0; i < 256; i++)
                            n[i] = i;
                        i = 0;
                        for (var r = 0; i < 256; i++) {
                            var a = i % o
                              , s = t[a >>> 2] >>> 24 - a % 4 * 8 & 255;
                            r = (r + n[i] + s) % 256;
                            var c = n[i];
                            n[i] = n[r],
                            n[r] = c
                        }
                        this._i = this._j = 0
                    },
                    _doProcessBlock: function(e, t) {
                        e[t] ^= r.call(this)
                    },
                    keySize: 8,
                    ivSize: 0
                });
                function r() {
                    for (var e = this._S, t = this._i, o = this._j, n = 0, i = 0; i < 4; i++) {
                        o = (o + e[t = (t + 1) % 256]) % 256;
                        var r = e[t];
                        e[t] = e[o],
                        e[o] = r,
                        n |= e[(e[t] + e[o]) % 256] << 24 - 8 * i
                    }
                    return this._i = t,
                    this._j = o,
                    n
                }
                t.RC4 = o._createHelper(i);
                var a = n.RC4Drop = i.extend({
                    cfg: i.cfg.extend({
                        drop: 192
                    }),
                    _doReset: function() {
                        i._doReset.call(this);
                        for (var e = this.cfg.drop; e > 0; e--)
                            r.call(this)
                    }
                });
                t.RC4Drop = o._createHelper(a)
            }(),
            e.RC4
        }
        ,
        "object" == typeof o ? t.exports = o = n(e("./core"), e("./enc-base64"), e("./md5"), e("./evpkdf"), e("./cipher-core")) : "function" == typeof define && define.amd ? define(["./core", "./enc-base64", "./md5", "./evpkdf", "./cipher-core"], n) : n((void 0).CryptoJS),
        cc._RF.pop()
    }
    , {
        "./cipher-core": "cipher-core",
        "./core": "core",
        "./enc-base64": "enc-base64",
        "./evpkdf": "evpkdf",
        "./md5": "md5"
    }],
    ripemd160: [function(e, t, o) {
        "use strict";
        var n;
        cc._RF.push(t, "224f1IxtpdGwrx6yoh0OGs7", "ripemd160"),
        n = function(e) {
            return function() {
                var t = e
                  , o = t.lib
                  , n = o.WordArray
                  , i = o.Hasher
                  , r = t.algo
                  , a = n.create([0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 7, 4, 13, 1, 10, 6, 15, 3, 12, 0, 9, 5, 2, 14, 11, 8, 3, 10, 14, 4, 9, 15, 8, 1, 2, 7, 0, 6, 13, 11, 5, 12, 1, 9, 11, 10, 0, 8, 12, 4, 13, 3, 7, 15, 14, 5, 6, 2, 4, 0, 5, 9, 7, 12, 2, 10, 14, 1, 3, 8, 11, 6, 15, 13])
                  , s = n.create([5, 14, 7, 0, 9, 2, 11, 4, 13, 6, 15, 8, 1, 10, 3, 12, 6, 11, 3, 7, 0, 13, 5, 10, 14, 15, 8, 12, 4, 9, 1, 2, 15, 5, 1, 3, 7, 14, 6, 9, 11, 8, 12, 2, 10, 0, 4, 13, 8, 6, 4, 1, 3, 11, 15, 0, 5, 12, 2, 13, 9, 7, 10, 14, 12, 15, 10, 4, 1, 5, 8, 7, 6, 2, 13, 14, 0, 3, 9, 11])
                  , c = n.create([11, 14, 15, 12, 5, 8, 7, 9, 11, 13, 14, 15, 6, 7, 9, 8, 7, 6, 8, 13, 11, 9, 7, 15, 7, 12, 15, 9, 11, 7, 13, 12, 11, 13, 6, 7, 14, 9, 13, 15, 14, 8, 13, 6, 5, 12, 7, 5, 11, 12, 14, 15, 14, 15, 9, 8, 9, 14, 5, 6, 8, 6, 5, 12, 9, 15, 5, 11, 6, 8, 13, 12, 5, 12, 13, 14, 11, 8, 5, 6])
                  , l = n.create([8, 9, 9, 11, 13, 15, 15, 5, 7, 7, 8, 11, 14, 14, 12, 6, 9, 13, 15, 7, 12, 8, 9, 11, 7, 7, 12, 7, 6, 15, 13, 11, 9, 7, 15, 11, 8, 6, 6, 14, 12, 13, 5, 14, 13, 13, 7, 5, 15, 5, 8, 11, 14, 14, 6, 14, 6, 9, 12, 9, 12, 5, 15, 8, 8, 5, 12, 9, 12, 5, 14, 6, 8, 13, 6, 5, 15, 13, 11, 11])
                  , f = n.create([0, 1518500249, 1859775393, 2400959708, 2840853838])
                  , h = n.create([1352829926, 1548603684, 1836072691, 2053994217, 0])
                  , d = r.RIPEMD160 = i.extend({
                    _doReset: function() {
                        this._hash = n.create([1732584193, 4023233417, 2562383102, 271733878, 3285377520])
                    },
                    _doProcessBlock: function(e, t) {
                        for (var o = 0; o < 16; o++) {
                            var n = t + o
                              , i = e[n];
                            e[n] = 16711935 & (i << 8 | i >>> 24) | 4278255360 & (i << 24 | i >>> 8)
                        }
                        var r, d, v, b, C, M, S, w, N, B, P, k = this._hash.words, R = f.words, T = h.words, I = a.words, D = s.words, L = c.words, x = l.words;
                        for (M = r = k[0],
                        S = d = k[1],
                        w = v = k[2],
                        N = b = k[3],
                        B = C = k[4],
                        o = 0; o < 80; o += 1)
                            P = r + e[t + I[o]] | 0,
                            P += o < 16 ? u(d, v, b) + R[0] : o < 32 ? p(d, v, b) + R[1] : o < 48 ? g(d, v, b) + R[2] : o < 64 ? _(d, v, b) + R[3] : y(d, v, b) + R[4],
                            P = (P = m(P |= 0, L[o])) + C | 0,
                            r = C,
                            C = b,
                            b = m(v, 10),
                            v = d,
                            d = P,
                            P = M + e[t + D[o]] | 0,
                            P += o < 16 ? y(S, w, N) + T[0] : o < 32 ? _(S, w, N) + T[1] : o < 48 ? g(S, w, N) + T[2] : o < 64 ? p(S, w, N) + T[3] : u(S, w, N) + T[4],
                            P = (P = m(P |= 0, x[o])) + B | 0,
                            M = B,
                            B = N,
                            N = m(w, 10),
                            w = S,
                            S = P;
                        P = k[1] + v + N | 0,
                        k[1] = k[2] + b + B | 0,
                        k[2] = k[3] + C + M | 0,
                        k[3] = k[4] + r + S | 0,
                        k[4] = k[0] + d + w | 0,
                        k[0] = P
                    },
                    _doFinalize: function() {
                        var e = this._data
                          , t = e.words
                          , o = 8 * this._nDataBytes
                          , n = 8 * e.sigBytes;
                        t[n >>> 5] |= 128 << 24 - n % 32,
                        t[14 + (n + 64 >>> 9 << 4)] = 16711935 & (o << 8 | o >>> 24) | 4278255360 & (o << 24 | o >>> 8),
                        e.sigBytes = 4 * (t.length + 1),
                        this._process();
                        for (var i = this._hash, r = i.words, a = 0; a < 5; a++) {
                            var s = r[a];
                            r[a] = 16711935 & (s << 8 | s >>> 24) | 4278255360 & (s << 24 | s >>> 8)
                        }
                        return i
                    },
                    clone: function() {
                        var e = i.clone.call(this);
                        return e._hash = this._hash.clone(),
                        e
                    }
                });
                function u(e, t, o) {
                    return e ^ t ^ o
                }
                function p(e, t, o) {
                    return e & t | ~e & o
                }
                function g(e, t, o) {
                    return (e | ~t) ^ o
                }
                function _(e, t, o) {
                    return e & o | t & ~o
                }
                function y(e, t, o) {
                    return e ^ (t | ~o)
                }
                function m(e, t) {
                    return e << t | e >>> 32 - t
                }
                t.RIPEMD160 = i._createHelper(d),
                t.HmacRIPEMD160 = i._createHmacHelper(d)
            }(Math),
            e.RIPEMD160
        }
        ,
        "object" == typeof o ? t.exports = o = n(e("./core")) : "function" == typeof define && define.amd ? define(["./core"], n) : n((void 0).CryptoJS),
        cc._RF.pop()
    }
    , {
        "./core": "core"
    }],
    sha1: [function(e, t, o) {
        "use strict";
        var n;
        cc._RF.push(t, "3316c/rSntB3J4Zk2D0aLfZ", "sha1"),
        n = function(e) {
            var t, o, n, i, r, a, s;
            return o = (t = e).lib,
            n = o.WordArray,
            i = o.Hasher,
            r = t.algo,
            a = [],
            s = r.SHA1 = i.extend({
                _doReset: function() {
                    this._hash = new n.init([1732584193, 4023233417, 2562383102, 271733878, 3285377520])
                },
                _doProcessBlock: function(e, t) {
                    for (var o = this._hash.words, n = o[0], i = o[1], r = o[2], s = o[3], c = o[4], l = 0; l < 80; l++) {
                        if (l < 16)
                            a[l] = 0 | e[t + l];
                        else {
                            var f = a[l - 3] ^ a[l - 8] ^ a[l - 14] ^ a[l - 16];
                            a[l] = f << 1 | f >>> 31
                        }
                        var h = (n << 5 | n >>> 27) + c + a[l];
                        h += l < 20 ? 1518500249 + (i & r | ~i & s) : l < 40 ? 1859775393 + (i ^ r ^ s) : l < 60 ? (i & r | i & s | r & s) - 1894007588 : (i ^ r ^ s) - 899497514,
                        c = s,
                        s = r,
                        r = i << 30 | i >>> 2,
                        i = n,
                        n = h
                    }
                    o[0] = o[0] + n | 0,
                    o[1] = o[1] + i | 0,
                    o[2] = o[2] + r | 0,
                    o[3] = o[3] + s | 0,
                    o[4] = o[4] + c | 0
                },
                _doFinalize: function() {
                    var e = this._data
                      , t = e.words
                      , o = 8 * this._nDataBytes
                      , n = 8 * e.sigBytes;
                    return t[n >>> 5] |= 128 << 24 - n % 32,
                    t[14 + (n + 64 >>> 9 << 4)] = Math.floor(o / 4294967296),
                    t[15 + (n + 64 >>> 9 << 4)] = o,
                    e.sigBytes = 4 * t.length,
                    this._process(),
                    this._hash
                },
                clone: function() {
                    var e = i.clone.call(this);
                    return e._hash = this._hash.clone(),
                    e
                }
            }),
            t.SHA1 = i._createHelper(s),
            t.HmacSHA1 = i._createHmacHelper(s),
            e.SHA1
        }
        ,
        "object" == typeof o ? t.exports = o = n(e("./core")) : "function" == typeof define && define.amd ? define(["./core"], n) : n((void 0).CryptoJS),
        cc._RF.pop()
    }
    , {
        "./core": "core"
    }],
    sha224: [function(e, t, o) {
        "use strict";
        var n;
        cc._RF.push(t, "d1bb9vHgNNLt6Mu6copDIIV", "sha224"),
        n = function(e) {
            var t, o, n, i, r;
            return o = (t = e).lib.WordArray,
            n = t.algo,
            i = n.SHA256,
            r = n.SHA224 = i.extend({
                _doReset: function() {
                    this._hash = new o.init([3238371032, 914150663, 812702999, 4144912697, 4290775857, 1750603025, 1694076839, 3204075428])
                },
                _doFinalize: function() {
                    var e = i._doFinalize.call(this);
                    return e.sigBytes -= 4,
                    e
                }
            }),
            t.SHA224 = i._createHelper(r),
            t.HmacSHA224 = i._createHmacHelper(r),
            e.SHA224
        }
        ,
        "object" == typeof o ? t.exports = o = n(e("./core"), e("./sha256")) : "function" == typeof define && define.amd ? define(["./core", "./sha256"], n) : n((void 0).CryptoJS),
        cc._RF.pop()
    }
    , {
        "./core": "core",
        "./sha256": "sha256"
    }],
    sha256: [function(e, t, o) {
        "use strict";
        var n;
        cc._RF.push(t, "db35b/q7BlHAo4qUMq4YzZ0", "sha256"),
        n = function(e) {
            return function(t) {
                var o = e
                  , n = o.lib
                  , i = n.WordArray
                  , r = n.Hasher
                  , a = o.algo
                  , s = []
                  , c = [];
                (function() {
                    function e(e) {
                        for (var o = t.sqrt(e), n = 2; n <= o; n++)
                            if (!(e % n))
                                return !1;
                        return !0
                    }
                    function o(e) {
                        return 4294967296 * (e - (0 | e)) | 0
                    }
                    for (var n = 2, i = 0; i < 64; )
                        e(n) && (i < 8 && (s[i] = o(t.pow(n, .5))),
                        c[i] = o(t.pow(n, 1 / 3)),
                        i++),
                        n++
                }
                )();
                var l = []
                  , f = a.SHA256 = r.extend({
                    _doReset: function() {
                        this._hash = new i.init(s.slice(0))
                    },
                    _doProcessBlock: function(e, t) {
                        for (var o = this._hash.words, n = o[0], i = o[1], r = o[2], a = o[3], s = o[4], f = o[5], h = o[6], d = o[7], u = 0; u < 64; u++) {
                            if (u < 16)
                                l[u] = 0 | e[t + u];
                            else {
                                var p = l[u - 15]
                                  , g = (p << 25 | p >>> 7) ^ (p << 14 | p >>> 18) ^ p >>> 3
                                  , _ = l[u - 2]
                                  , y = (_ << 15 | _ >>> 17) ^ (_ << 13 | _ >>> 19) ^ _ >>> 10;
                                l[u] = g + l[u - 7] + y + l[u - 16]
                            }
                            var m = n & i ^ n & r ^ i & r
                              , v = (n << 30 | n >>> 2) ^ (n << 19 | n >>> 13) ^ (n << 10 | n >>> 22)
                              , b = d + ((s << 26 | s >>> 6) ^ (s << 21 | s >>> 11) ^ (s << 7 | s >>> 25)) + (s & f ^ ~s & h) + c[u] + l[u];
                            d = h,
                            h = f,
                            f = s,
                            s = a + b | 0,
                            a = r,
                            r = i,
                            i = n,
                            n = b + (v + m) | 0
                        }
                        o[0] = o[0] + n | 0,
                        o[1] = o[1] + i | 0,
                        o[2] = o[2] + r | 0,
                        o[3] = o[3] + a | 0,
                        o[4] = o[4] + s | 0,
                        o[5] = o[5] + f | 0,
                        o[6] = o[6] + h | 0,
                        o[7] = o[7] + d | 0
                    },
                    _doFinalize: function() {
                        var e = this._data
                          , o = e.words
                          , n = 8 * this._nDataBytes
                          , i = 8 * e.sigBytes;
                        return o[i >>> 5] |= 128 << 24 - i % 32,
                        o[14 + (i + 64 >>> 9 << 4)] = t.floor(n / 4294967296),
                        o[15 + (i + 64 >>> 9 << 4)] = n,
                        e.sigBytes = 4 * o.length,
                        this._process(),
                        this._hash
                    },
                    clone: function() {
                        var e = r.clone.call(this);
                        return e._hash = this._hash.clone(),
                        e
                    }
                });
                o.SHA256 = r._createHelper(f),
                o.HmacSHA256 = r._createHmacHelper(f)
            }(Math),
            e.SHA256
        }
        ,
        "object" == typeof o ? t.exports = o = n(e("./core")) : "function" == typeof define && define.amd ? define(["./core"], n) : n((void 0).CryptoJS),
        cc._RF.pop()
    }
    , {
        "./core": "core"
    }],
    sha384: [function(e, t, o) {
        "use strict";
        var n;
        cc._RF.push(t, "473895C7YVK94qOedpELTUU", "sha384"),
        n = function(e) {
            var t, o, n, i, r, a, s;
            return o = (t = e).x64,
            n = o.Word,
            i = o.WordArray,
            r = t.algo,
            a = r.SHA512,
            s = r.SHA384 = a.extend({
                _doReset: function() {
                    this._hash = new i.init([new n.init(3418070365,3238371032), new n.init(1654270250,914150663), new n.init(2438529370,812702999), new n.init(355462360,4144912697), new n.init(1731405415,4290775857), new n.init(2394180231,1750603025), new n.init(3675008525,1694076839), new n.init(1203062813,3204075428)])
                },
                _doFinalize: function() {
                    var e = a._doFinalize.call(this);
                    return e.sigBytes -= 16,
                    e
                }
            }),
            t.SHA384 = a._createHelper(s),
            t.HmacSHA384 = a._createHmacHelper(s),
            e.SHA384
        }
        ,
        "object" == typeof o ? t.exports = o = n(e("./core"), e("./x64-core"), e("./sha512")) : "function" == typeof define && define.amd ? define(["./core", "./x64-core", "./sha512"], n) : n((void 0).CryptoJS),
        cc._RF.pop()
    }
    , {
        "./core": "core",
        "./sha512": "sha512",
        "./x64-core": "x64-core"
    }],
    sha3: [function(e, t, o) {
        "use strict";
        var n;
        cc._RF.push(t, "9489f413WpObLwrPrwWLD04", "sha3"),
        n = function(e) {
            return function(t) {
                var o = e
                  , n = o.lib
                  , i = n.WordArray
                  , r = n.Hasher
                  , a = o.x64.Word
                  , s = o.algo
                  , c = []
                  , l = []
                  , f = [];
                (function() {
                    for (var e = 1, t = 0, o = 0; o < 24; o++) {
                        c[e + 5 * t] = (o + 1) * (o + 2) / 2 % 64;
                        var n = (2 * e + 3 * t) % 5;
                        e = t % 5,
                        t = n
                    }
                    for (e = 0; e < 5; e++)
                        for (t = 0; t < 5; t++)
                            l[e + 5 * t] = t + (2 * e + 3 * t) % 5 * 5;
                    for (var i = 1, r = 0; r < 24; r++) {
                        for (var s = 0, h = 0, d = 0; d < 7; d++) {
                            if (1 & i) {
                                var u = (1 << d) - 1;
                                u < 32 ? h ^= 1 << u : s ^= 1 << u - 32
                            }
                            128 & i ? i = i << 1 ^ 113 : i <<= 1
                        }
                        f[r] = a.create(s, h)
                    }
                }
                )();
                var h = [];
                (function() {
                    for (var e = 0; e < 25; e++)
                        h[e] = a.create()
                }
                )();
                var d = s.SHA3 = r.extend({
                    cfg: r.cfg.extend({
                        outputLength: 512
                    }),
                    _doReset: function() {
                        for (var e = this._state = [], t = 0; t < 25; t++)
                            e[t] = new a.init;
                        this.blockSize = (1600 - 2 * this.cfg.outputLength) / 32
                    },
                    _doProcessBlock: function(e, t) {
                        for (var o = this._state, n = this.blockSize / 2, i = 0; i < n; i++) {
                            var r = e[t + 2 * i]
                              , a = e[t + 2 * i + 1];
                            r = 16711935 & (r << 8 | r >>> 24) | 4278255360 & (r << 24 | r >>> 8),
                            a = 16711935 & (a << 8 | a >>> 24) | 4278255360 & (a << 24 | a >>> 8),
                            (k = o[i]).high ^= a,
                            k.low ^= r
                        }
                        for (var s = 0; s < 24; s++) {
                            for (var d = 0; d < 5; d++) {
                                for (var u = 0, p = 0, g = 0; g < 5; g++)
                                    u ^= (k = o[d + 5 * g]).high,
                                    p ^= k.low;
                                var _ = h[d];
                                _.high = u,
                                _.low = p
                            }
                            for (d = 0; d < 5; d++) {
                                var y = h[(d + 4) % 5]
                                  , m = h[(d + 1) % 5]
                                  , v = m.high
                                  , b = m.low;
                                for (u = y.high ^ (v << 1 | b >>> 31),
                                p = y.low ^ (b << 1 | v >>> 31),
                                g = 0; g < 5; g++)
                                    (k = o[d + 5 * g]).high ^= u,
                                    k.low ^= p
                            }
                            for (var C = 1; C < 25; C++) {
                                var M = (k = o[C]).high
                                  , S = k.low
                                  , w = c[C];
                                w < 32 ? (u = M << w | S >>> 32 - w,
                                p = S << w | M >>> 32 - w) : (u = S << w - 32 | M >>> 64 - w,
                                p = M << w - 32 | S >>> 64 - w);
                                var N = h[l[C]];
                                N.high = u,
                                N.low = p
                            }
                            var B = h[0]
                              , P = o[0];
                            for (B.high = P.high,
                            B.low = P.low,
                            d = 0; d < 5; d++)
                                for (g = 0; g < 5; g++) {
                                    var k = o[C = d + 5 * g]
                                      , R = h[C]
                                      , T = h[(d + 1) % 5 + 5 * g]
                                      , I = h[(d + 2) % 5 + 5 * g];
                                    k.high = R.high ^ ~T.high & I.high,
                                    k.low = R.low ^ ~T.low & I.low
                                }
                            k = o[0];
                            var D = f[s];
                            k.high ^= D.high,
                            k.low ^= D.low
                        }
                    },
                    _doFinalize: function() {
                        var e = this._data
                          , o = e.words
                          , n = (this._nDataBytes,
                        8 * e.sigBytes)
                          , r = 32 * this.blockSize;
                        o[n >>> 5] |= 1 << 24 - n % 32,
                        o[(t.ceil((n + 1) / r) * r >>> 5) - 1] |= 128,
                        e.sigBytes = 4 * o.length,
                        this._process();
                        for (var a = this._state, s = this.cfg.outputLength / 8, c = s / 8, l = [], f = 0; f < c; f++) {
                            var h = a[f]
                              , d = h.high
                              , u = h.low;
                            d = 16711935 & (d << 8 | d >>> 24) | 4278255360 & (d << 24 | d >>> 8),
                            u = 16711935 & (u << 8 | u >>> 24) | 4278255360 & (u << 24 | u >>> 8),
                            l.push(u),
                            l.push(d)
                        }
                        return new i.init(l,s)
                    },
                    clone: function() {
                        for (var e = r.clone.call(this), t = e._state = this._state.slice(0), o = 0; o < 25; o++)
                            t[o] = t[o].clone();
                        return e
                    }
                });
                o.SHA3 = r._createHelper(d),
                o.HmacSHA3 = r._createHmacHelper(d)
            }(Math),
            e.SHA3
        }
        ,
        "object" == typeof o ? t.exports = o = n(e("./core"), e("./x64-core")) : "function" == typeof define && define.amd ? define(["./core", "./x64-core"], n) : n((void 0).CryptoJS),
        cc._RF.pop()
    }
    , {
        "./core": "core",
        "./x64-core": "x64-core"
    }],
    sha512: [function(e, t, o) {
        "use strict";
        var n;
        cc._RF.push(t, "ee724DmyZ1AfrdxrDAQ2NQ4", "sha512"),
        n = function(e) {
            return function() {
                var t = e
                  , o = t.lib.Hasher
                  , n = t.x64
                  , i = n.Word
                  , r = n.WordArray
                  , a = t.algo;
                function s() {
                    return i.create.apply(i, arguments)
                }
                var c = [s(1116352408, 3609767458), s(1899447441, 602891725), s(3049323471, 3964484399), s(3921009573, 2173295548), s(961987163, 4081628472), s(1508970993, 3053834265), s(2453635748, 2937671579), s(2870763221, 3664609560), s(3624381080, 2734883394), s(310598401, 1164996542), s(607225278, 1323610764), s(1426881987, 3590304994), s(1925078388, 4068182383), s(2162078206, 991336113), s(2614888103, 633803317), s(3248222580, 3479774868), s(3835390401, 2666613458), s(4022224774, 944711139), s(264347078, 2341262773), s(604807628, 2007800933), s(770255983, 1495990901), s(1249150122, 1856431235), s(1555081692, 3175218132), s(1996064986, 2198950837), s(2554220882, 3999719339), s(2821834349, 766784016), s(2952996808, 2566594879), s(3210313671, 3203337956), s(3336571891, 1034457026), s(3584528711, 2466948901), s(113926993, 3758326383), s(338241895, 168717936), s(666307205, 1188179964), s(773529912, 1546045734), s(1294757372, 1522805485), s(1396182291, 2643833823), s(1695183700, 2343527390), s(1986661051, 1014477480), s(2177026350, 1206759142), s(2456956037, 344077627), s(2730485921, 1290863460), s(2820302411, 3158454273), s(3259730800, 3505952657), s(3345764771, 106217008), s(3516065817, 3606008344), s(3600352804, 1432725776), s(4094571909, 1467031594), s(275423344, 851169720), s(430227734, 3100823752), s(506948616, 1363258195), s(659060556, 3750685593), s(883997877, 3785050280), s(958139571, 3318307427), s(1322822218, 3812723403), s(1537002063, 2003034995), s(1747873779, 3602036899), s(1955562222, 1575990012), s(2024104815, 1125592928), s(2227730452, 2716904306), s(2361852424, 442776044), s(2428436474, 593698344), s(2756734187, 3733110249), s(3204031479, 2999351573), s(3329325298, 3815920427), s(3391569614, 3928383900), s(3515267271, 566280711), s(3940187606, 3454069534), s(4118630271, 4000239992), s(116418474, 1914138554), s(174292421, 2731055270), s(289380356, 3203993006), s(460393269, 320620315), s(685471733, 587496836), s(852142971, 1086792851), s(1017036298, 365543100), s(1126000580, 2618297676), s(1288033470, 3409855158), s(1501505948, 4234509866), s(1607167915, 987167468), s(1816402316, 1246189591)]
                  , l = [];
                (function() {
                    for (var e = 0; e < 80; e++)
                        l[e] = s()
                }
                )();
                var f = a.SHA512 = o.extend({
                    _doReset: function() {
                        this._hash = new r.init([new i.init(1779033703,4089235720), new i.init(3144134277,2227873595), new i.init(1013904242,4271175723), new i.init(2773480762,1595750129), new i.init(1359893119,2917565137), new i.init(2600822924,725511199), new i.init(528734635,4215389547), new i.init(1541459225,327033209)])
                    },
                    _doProcessBlock: function(e, t) {
                        for (var o = this._hash.words, n = o[0], i = o[1], r = o[2], a = o[3], s = o[4], f = o[5], h = o[6], d = o[7], u = n.high, p = n.low, g = i.high, _ = i.low, y = r.high, m = r.low, v = a.high, b = a.low, C = s.high, M = s.low, S = f.high, w = f.low, N = h.high, B = h.low, P = d.high, k = d.low, R = u, T = p, I = g, D = _, L = y, x = m, E = v, O = b, F = C, A = M, j = S, U = w, G = N, H = B, z = P, V = k, W = 0; W < 80; W++) {
                            var J = l[W];
                            if (W < 16)
                                var q = J.high = 0 | e[t + 2 * W]
                                  , K = J.low = 0 | e[t + 2 * W + 1];
                            else {
                                var X = l[W - 15]
                                  , Z = X.high
                                  , Y = X.low
                                  , Q = (Z >>> 1 | Y << 31) ^ (Z >>> 8 | Y << 24) ^ Z >>> 7
                                  , $ = (Y >>> 1 | Z << 31) ^ (Y >>> 8 | Z << 24) ^ (Y >>> 7 | Z << 25)
                                  , ee = l[W - 2]
                                  , te = ee.high
                                  , oe = ee.low
                                  , ne = (te >>> 19 | oe << 13) ^ (te << 3 | oe >>> 29) ^ te >>> 6
                                  , ie = (oe >>> 19 | te << 13) ^ (oe << 3 | te >>> 29) ^ (oe >>> 6 | te << 26)
                                  , re = l[W - 7]
                                  , ae = re.high
                                  , se = re.low
                                  , ce = l[W - 16]
                                  , le = ce.high
                                  , fe = ce.low;
                                q = (q = (q = Q + ae + ((K = $ + se) >>> 0 < $ >>> 0 ? 1 : 0)) + ne + ((K += ie) >>> 0 < ie >>> 0 ? 1 : 0)) + le + ((K += fe) >>> 0 < fe >>> 0 ? 1 : 0),
                                J.high = q,
                                J.low = K
                            }
                            var he, de = F & j ^ ~F & G, ue = A & U ^ ~A & H, pe = R & I ^ R & L ^ I & L, ge = T & D ^ T & x ^ D & x, _e = (R >>> 28 | T << 4) ^ (R << 30 | T >>> 2) ^ (R << 25 | T >>> 7), ye = (T >>> 28 | R << 4) ^ (T << 30 | R >>> 2) ^ (T << 25 | R >>> 7), me = (F >>> 14 | A << 18) ^ (F >>> 18 | A << 14) ^ (F << 23 | A >>> 9), ve = (A >>> 14 | F << 18) ^ (A >>> 18 | F << 14) ^ (A << 23 | F >>> 9), be = c[W], Ce = be.high, Me = be.low, Se = z + me + ((he = V + ve) >>> 0 < V >>> 0 ? 1 : 0), we = ye + ge;
                            z = G,
                            V = H,
                            G = j,
                            H = U,
                            j = F,
                            U = A,
                            F = E + (Se = (Se = (Se = Se + de + ((he += ue) >>> 0 < ue >>> 0 ? 1 : 0)) + Ce + ((he += Me) >>> 0 < Me >>> 0 ? 1 : 0)) + q + ((he += K) >>> 0 < K >>> 0 ? 1 : 0)) + ((A = O + he | 0) >>> 0 < O >>> 0 ? 1 : 0) | 0,
                            E = L,
                            O = x,
                            L = I,
                            x = D,
                            I = R,
                            D = T,
                            R = Se + (_e + pe + (we >>> 0 < ye >>> 0 ? 1 : 0)) + ((T = he + we | 0) >>> 0 < he >>> 0 ? 1 : 0) | 0
                        }
                        p = n.low = p + T,
                        n.high = u + R + (p >>> 0 < T >>> 0 ? 1 : 0),
                        _ = i.low = _ + D,
                        i.high = g + I + (_ >>> 0 < D >>> 0 ? 1 : 0),
                        m = r.low = m + x,
                        r.high = y + L + (m >>> 0 < x >>> 0 ? 1 : 0),
                        b = a.low = b + O,
                        a.high = v + E + (b >>> 0 < O >>> 0 ? 1 : 0),
                        M = s.low = M + A,
                        s.high = C + F + (M >>> 0 < A >>> 0 ? 1 : 0),
                        w = f.low = w + U,
                        f.high = S + j + (w >>> 0 < U >>> 0 ? 1 : 0),
                        B = h.low = B + H,
                        h.high = N + G + (B >>> 0 < H >>> 0 ? 1 : 0),
                        k = d.low = k + V,
                        d.high = P + z + (k >>> 0 < V >>> 0 ? 1 : 0)
                    },
                    _doFinalize: function() {
                        var e = this._data
                          , t = e.words
                          , o = 8 * this._nDataBytes
                          , n = 8 * e.sigBytes;
                        return t[n >>> 5] |= 128 << 24 - n % 32,
                        t[30 + (n + 128 >>> 10 << 5)] = Math.floor(o / 4294967296),
                        t[31 + (n + 128 >>> 10 << 5)] = o,
                        e.sigBytes = 4 * t.length,
                        this._process(),
                        this._hash.toX32()
                    },
                    clone: function() {
                        var e = o.clone.call(this);
                        return e._hash = this._hash.clone(),
                        e
                    },
                    blockSize: 32
                });
                t.SHA512 = o._createHelper(f),
                t.HmacSHA512 = o._createHmacHelper(f)
            }(),
            e.SHA512
        }
        ,
        "object" == typeof o ? t.exports = o = n(e("./core"), e("./x64-core")) : "function" == typeof define && define.amd ? define(["./core", "./x64-core"], n) : n((void 0).CryptoJS),
        cc._RF.pop()
    }
    , {
        "./core": "core",
        "./x64-core": "x64-core"
    }],
    tripledes: [function(e, t, o) {
        "use strict";
        var n;
        cc._RF.push(t, "93678n1SJ5Jl4FVhmvCRT/E", "tripledes"),
        n = function(e) {
            return function() {
                var t = e
                  , o = t.lib
                  , n = o.WordArray
                  , i = o.BlockCipher
                  , r = t.algo
                  , a = [57, 49, 41, 33, 25, 17, 9, 1, 58, 50, 42, 34, 26, 18, 10, 2, 59, 51, 43, 35, 27, 19, 11, 3, 60, 52, 44, 36, 63, 55, 47, 39, 31, 23, 15, 7, 62, 54, 46, 38, 30, 22, 14, 6, 61, 53, 45, 37, 29, 21, 13, 5, 28, 20, 12, 4]
                  , s = [14, 17, 11, 24, 1, 5, 3, 28, 15, 6, 21, 10, 23, 19, 12, 4, 26, 8, 16, 7, 27, 20, 13, 2, 41, 52, 31, 37, 47, 55, 30, 40, 51, 45, 33, 48, 44, 49, 39, 56, 34, 53, 46, 42, 50, 36, 29, 32]
                  , c = [1, 2, 4, 6, 8, 10, 12, 14, 15, 17, 19, 21, 23, 25, 27, 28]
                  , l = [{
                    0: 8421888,
                    268435456: 32768,
                    536870912: 8421378,
                    805306368: 2,
                    1073741824: 512,
                    1342177280: 8421890,
                    1610612736: 8389122,
                    1879048192: 8388608,
                    2147483648: 514,
                    2415919104: 8389120,
                    2684354560: 33280,
                    2952790016: 8421376,
                    3221225472: 32770,
                    3489660928: 8388610,
                    3758096384: 0,
                    4026531840: 33282,
                    134217728: 0,
                    402653184: 8421890,
                    671088640: 33282,
                    939524096: 32768,
                    1207959552: 8421888,
                    1476395008: 512,
                    1744830464: 8421378,
                    2013265920: 2,
                    2281701376: 8389120,
                    2550136832: 33280,
                    2818572288: 8421376,
                    3087007744: 8389122,
                    3355443200: 8388610,
                    3623878656: 32770,
                    3892314112: 514,
                    4160749568: 8388608,
                    1: 32768,
                    268435457: 2,
                    536870913: 8421888,
                    805306369: 8388608,
                    1073741825: 8421378,
                    1342177281: 33280,
                    1610612737: 512,
                    1879048193: 8389122,
                    2147483649: 8421890,
                    2415919105: 8421376,
                    2684354561: 8388610,
                    2952790017: 33282,
                    3221225473: 514,
                    3489660929: 8389120,
                    3758096385: 32770,
                    4026531841: 0,
                    134217729: 8421890,
                    402653185: 8421376,
                    671088641: 8388608,
                    939524097: 512,
                    1207959553: 32768,
                    1476395009: 8388610,
                    1744830465: 2,
                    2013265921: 33282,
                    2281701377: 32770,
                    2550136833: 8389122,
                    2818572289: 514,
                    3087007745: 8421888,
                    3355443201: 8389120,
                    3623878657: 0,
                    3892314113: 33280,
                    4160749569: 8421378
                }, {
                    0: 1074282512,
                    16777216: 16384,
                    33554432: 524288,
                    50331648: 1074266128,
                    67108864: 1073741840,
                    83886080: 1074282496,
                    100663296: 1073758208,
                    117440512: 16,
                    134217728: 540672,
                    150994944: 1073758224,
                    167772160: 1073741824,
                    184549376: 540688,
                    201326592: 524304,
                    218103808: 0,
                    234881024: 16400,
                    251658240: 1074266112,
                    8388608: 1073758208,
                    25165824: 540688,
                    41943040: 16,
                    58720256: 1073758224,
                    75497472: 1074282512,
                    92274688: 1073741824,
                    109051904: 524288,
                    125829120: 1074266128,
                    142606336: 524304,
                    159383552: 0,
                    176160768: 16384,
                    192937984: 1074266112,
                    209715200: 1073741840,
                    226492416: 540672,
                    243269632: 1074282496,
                    260046848: 16400,
                    268435456: 0,
                    285212672: 1074266128,
                    301989888: 1073758224,
                    318767104: 1074282496,
                    335544320: 1074266112,
                    352321536: 16,
                    369098752: 540688,
                    385875968: 16384,
                    402653184: 16400,
                    419430400: 524288,
                    436207616: 524304,
                    452984832: 1073741840,
                    469762048: 540672,
                    486539264: 1073758208,
                    503316480: 1073741824,
                    520093696: 1074282512,
                    276824064: 540688,
                    293601280: 524288,
                    310378496: 1074266112,
                    327155712: 16384,
                    343932928: 1073758208,
                    360710144: 1074282512,
                    377487360: 16,
                    394264576: 1073741824,
                    411041792: 1074282496,
                    427819008: 1073741840,
                    444596224: 1073758224,
                    461373440: 524304,
                    478150656: 0,
                    494927872: 16400,
                    511705088: 1074266128,
                    528482304: 540672
                }, {
                    0: 260,
                    1048576: 0,
                    2097152: 67109120,
                    3145728: 65796,
                    4194304: 65540,
                    5242880: 67108868,
                    6291456: 67174660,
                    7340032: 67174400,
                    8388608: 67108864,
                    9437184: 67174656,
                    10485760: 65792,
                    11534336: 67174404,
                    12582912: 67109124,
                    13631488: 65536,
                    14680064: 4,
                    15728640: 256,
                    524288: 67174656,
                    1572864: 67174404,
                    2621440: 0,
                    3670016: 67109120,
                    4718592: 67108868,
                    5767168: 65536,
                    6815744: 65540,
                    7864320: 260,
                    8912896: 4,
                    9961472: 256,
                    11010048: 67174400,
                    12058624: 65796,
                    13107200: 65792,
                    14155776: 67109124,
                    15204352: 67174660,
                    16252928: 67108864,
                    16777216: 67174656,
                    17825792: 65540,
                    18874368: 65536,
                    19922944: 67109120,
                    20971520: 256,
                    22020096: 67174660,
                    23068672: 67108868,
                    24117248: 0,
                    25165824: 67109124,
                    26214400: 67108864,
                    27262976: 4,
                    28311552: 65792,
                    29360128: 67174400,
                    30408704: 260,
                    31457280: 65796,
                    32505856: 67174404,
                    17301504: 67108864,
                    18350080: 260,
                    19398656: 67174656,
                    20447232: 0,
                    21495808: 65540,
                    22544384: 67109120,
                    23592960: 256,
                    24641536: 67174404,
                    25690112: 65536,
                    26738688: 67174660,
                    27787264: 65796,
                    28835840: 67108868,
                    29884416: 67109124,
                    30932992: 67174400,
                    31981568: 4,
                    33030144: 65792
                }, {
                    0: 2151682048,
                    65536: 2147487808,
                    131072: 4198464,
                    196608: 2151677952,
                    262144: 0,
                    327680: 4198400,
                    393216: 2147483712,
                    458752: 4194368,
                    524288: 2147483648,
                    589824: 4194304,
                    655360: 64,
                    720896: 2147487744,
                    786432: 2151678016,
                    851968: 4160,
                    917504: 4096,
                    983040: 2151682112,
                    32768: 2147487808,
                    98304: 64,
                    163840: 2151678016,
                    229376: 2147487744,
                    294912: 4198400,
                    360448: 2151682112,
                    425984: 0,
                    491520: 2151677952,
                    557056: 4096,
                    622592: 2151682048,
                    688128: 4194304,
                    753664: 4160,
                    819200: 2147483648,
                    884736: 4194368,
                    950272: 4198464,
                    1015808: 2147483712,
                    1048576: 4194368,
                    1114112: 4198400,
                    1179648: 2147483712,
                    1245184: 0,
                    1310720: 4160,
                    1376256: 2151678016,
                    1441792: 2151682048,
                    1507328: 2147487808,
                    1572864: 2151682112,
                    1638400: 2147483648,
                    1703936: 2151677952,
                    1769472: 4198464,
                    1835008: 2147487744,
                    1900544: 4194304,
                    1966080: 64,
                    2031616: 4096,
                    1081344: 2151677952,
                    1146880: 2151682112,
                    1212416: 0,
                    1277952: 4198400,
                    1343488: 4194368,
                    1409024: 2147483648,
                    1474560: 2147487808,
                    1540096: 64,
                    1605632: 2147483712,
                    1671168: 4096,
                    1736704: 2147487744,
                    1802240: 2151678016,
                    1867776: 4160,
                    1933312: 2151682048,
                    1998848: 4194304,
                    2064384: 4198464
                }, {
                    0: 128,
                    4096: 17039360,
                    8192: 262144,
                    12288: 536870912,
                    16384: 537133184,
                    20480: 16777344,
                    24576: 553648256,
                    28672: 262272,
                    32768: 16777216,
                    36864: 537133056,
                    40960: 536871040,
                    45056: 553910400,
                    49152: 553910272,
                    53248: 0,
                    57344: 17039488,
                    61440: 553648128,
                    2048: 17039488,
                    6144: 553648256,
                    10240: 128,
                    14336: 17039360,
                    18432: 262144,
                    22528: 537133184,
                    26624: 553910272,
                    30720: 536870912,
                    34816: 537133056,
                    38912: 0,
                    43008: 553910400,
                    47104: 16777344,
                    51200: 536871040,
                    55296: 553648128,
                    59392: 16777216,
                    63488: 262272,
                    65536: 262144,
                    69632: 128,
                    73728: 536870912,
                    77824: 553648256,
                    81920: 16777344,
                    86016: 553910272,
                    90112: 537133184,
                    94208: 16777216,
                    98304: 553910400,
                    102400: 553648128,
                    106496: 17039360,
                    110592: 537133056,
                    114688: 262272,
                    118784: 536871040,
                    122880: 0,
                    126976: 17039488,
                    67584: 553648256,
                    71680: 16777216,
                    75776: 17039360,
                    79872: 537133184,
                    83968: 536870912,
                    88064: 17039488,
                    92160: 128,
                    96256: 553910272,
                    100352: 262272,
                    104448: 553910400,
                    108544: 0,
                    112640: 553648128,
                    116736: 16777344,
                    120832: 262144,
                    124928: 537133056,
                    129024: 536871040
                }, {
                    0: 268435464,
                    256: 8192,
                    512: 270532608,
                    768: 270540808,
                    1024: 268443648,
                    1280: 2097152,
                    1536: 2097160,
                    1792: 268435456,
                    2048: 0,
                    2304: 268443656,
                    2560: 2105344,
                    2816: 8,
                    3072: 270532616,
                    3328: 2105352,
                    3584: 8200,
                    3840: 270540800,
                    128: 270532608,
                    384: 270540808,
                    640: 8,
                    896: 2097152,
                    1152: 2105352,
                    1408: 268435464,
                    1664: 268443648,
                    1920: 8200,
                    2176: 2097160,
                    2432: 8192,
                    2688: 268443656,
                    2944: 270532616,
                    3200: 0,
                    3456: 270540800,
                    3712: 2105344,
                    3968: 268435456,
                    4096: 268443648,
                    4352: 270532616,
                    4608: 270540808,
                    4864: 8200,
                    5120: 2097152,
                    5376: 268435456,
                    5632: 268435464,
                    5888: 2105344,
                    6144: 2105352,
                    6400: 0,
                    6656: 8,
                    6912: 270532608,
                    7168: 8192,
                    7424: 268443656,
                    7680: 270540800,
                    7936: 2097160,
                    4224: 8,
                    4480: 2105344,
                    4736: 2097152,
                    4992: 268435464,
                    5248: 268443648,
                    5504: 8200,
                    5760: 270540808,
                    6016: 270532608,
                    6272: 270540800,
                    6528: 270532616,
                    6784: 8192,
                    7040: 2105352,
                    7296: 2097160,
                    7552: 0,
                    7808: 268435456,
                    8064: 268443656
                }, {
                    0: 1048576,
                    16: 33555457,
                    32: 1024,
                    48: 1049601,
                    64: 34604033,
                    80: 0,
                    96: 1,
                    112: 34603009,
                    128: 33555456,
                    144: 1048577,
                    160: 33554433,
                    176: 34604032,
                    192: 34603008,
                    208: 1025,
                    224: 1049600,
                    240: 33554432,
                    8: 34603009,
                    24: 0,
                    40: 33555457,
                    56: 34604032,
                    72: 1048576,
                    88: 33554433,
                    104: 33554432,
                    120: 1025,
                    136: 1049601,
                    152: 33555456,
                    168: 34603008,
                    184: 1048577,
                    200: 1024,
                    216: 34604033,
                    232: 1,
                    248: 1049600,
                    256: 33554432,
                    272: 1048576,
                    288: 33555457,
                    304: 34603009,
                    320: 1048577,
                    336: 33555456,
                    352: 34604032,
                    368: 1049601,
                    384: 1025,
                    400: 34604033,
                    416: 1049600,
                    432: 1,
                    448: 0,
                    464: 34603008,
                    480: 33554433,
                    496: 1024,
                    264: 1049600,
                    280: 33555457,
                    296: 34603009,
                    312: 1,
                    328: 33554432,
                    344: 1048576,
                    360: 1025,
                    376: 34604032,
                    392: 33554433,
                    408: 34603008,
                    424: 0,
                    440: 34604033,
                    456: 1049601,
                    472: 1024,
                    488: 33555456,
                    504: 1048577
                }, {
                    0: 134219808,
                    1: 131072,
                    2: 134217728,
                    3: 32,
                    4: 131104,
                    5: 134350880,
                    6: 134350848,
                    7: 2048,
                    8: 134348800,
                    9: 134219776,
                    10: 133120,
                    11: 134348832,
                    12: 2080,
                    13: 0,
                    14: 134217760,
                    15: 133152,
                    2147483648: 2048,
                    2147483649: 134350880,
                    2147483650: 134219808,
                    2147483651: 134217728,
                    2147483652: 134348800,
                    2147483653: 133120,
                    2147483654: 133152,
                    2147483655: 32,
                    2147483656: 134217760,
                    2147483657: 2080,
                    2147483658: 131104,
                    2147483659: 134350848,
                    2147483660: 0,
                    2147483661: 134348832,
                    2147483662: 134219776,
                    2147483663: 131072,
                    16: 133152,
                    17: 134350848,
                    18: 32,
                    19: 2048,
                    20: 134219776,
                    21: 134217760,
                    22: 134348832,
                    23: 131072,
                    24: 0,
                    25: 131104,
                    26: 134348800,
                    27: 134219808,
                    28: 134350880,
                    29: 133120,
                    30: 2080,
                    31: 134217728,
                    2147483664: 131072,
                    2147483665: 2048,
                    2147483666: 134348832,
                    2147483667: 133152,
                    2147483668: 32,
                    2147483669: 134348800,
                    2147483670: 134217728,
                    2147483671: 134219808,
                    2147483672: 134350880,
                    2147483673: 134217760,
                    2147483674: 134219776,
                    2147483675: 0,
                    2147483676: 133120,
                    2147483677: 2080,
                    2147483678: 131104,
                    2147483679: 134350848
                }]
                  , f = [4160749569, 528482304, 33030144, 2064384, 129024, 8064, 504, 2147483679]
                  , h = r.DES = i.extend({
                    _doReset: function() {
                        for (var e = this._key.words, t = [], o = 0; o < 56; o++) {
                            var n = a[o] - 1;
                            t[o] = e[n >>> 5] >>> 31 - n % 32 & 1
                        }
                        for (var i = this._subKeys = [], r = 0; r < 16; r++) {
                            var l = i[r] = []
                              , f = c[r];
                            for (o = 0; o < 24; o++)
                                l[o / 6 | 0] |= t[(s[o] - 1 + f) % 28] << 31 - o % 6,
                                l[4 + (o / 6 | 0)] |= t[28 + (s[o + 24] - 1 + f) % 28] << 31 - o % 6;
                            for (l[0] = l[0] << 1 | l[0] >>> 31,
                            o = 1; o < 7; o++)
                                l[o] = l[o] >>> 4 * (o - 1) + 3;
                            l[7] = l[7] << 5 | l[7] >>> 27
                        }
                        var h = this._invSubKeys = [];
                        for (o = 0; o < 16; o++)
                            h[o] = i[15 - o]
                    },
                    encryptBlock: function(e, t) {
                        this._doCryptBlock(e, t, this._subKeys)
                    },
                    decryptBlock: function(e, t) {
                        this._doCryptBlock(e, t, this._invSubKeys)
                    },
                    _doCryptBlock: function(e, t, o) {
                        this._lBlock = e[t],
                        this._rBlock = e[t + 1],
                        d.call(this, 4, 252645135),
                        d.call(this, 16, 65535),
                        u.call(this, 2, 858993459),
                        u.call(this, 8, 16711935),
                        d.call(this, 1, 1431655765);
                        for (var n = 0; n < 16; n++) {
                            for (var i = o[n], r = this._lBlock, a = this._rBlock, s = 0, c = 0; c < 8; c++)
                                s |= l[c][((a ^ i[c]) & f[c]) >>> 0];
                            this._lBlock = a,
                            this._rBlock = r ^ s
                        }
                        var h = this._lBlock;
                        this._lBlock = this._rBlock,
                        this._rBlock = h,
                        d.call(this, 1, 1431655765),
                        u.call(this, 8, 16711935),
                        u.call(this, 2, 858993459),
                        d.call(this, 16, 65535),
                        d.call(this, 4, 252645135),
                        e[t] = this._lBlock,
                        e[t + 1] = this._rBlock
                    },
                    keySize: 2,
                    ivSize: 2,
                    blockSize: 2
                });
                function d(e, t) {
                    var o = (this._lBlock >>> e ^ this._rBlock) & t;
                    this._rBlock ^= o,
                    this._lBlock ^= o << e
                }
                function u(e, t) {
                    var o = (this._rBlock >>> e ^ this._lBlock) & t;
                    this._lBlock ^= o,
                    this._rBlock ^= o << e
                }
                t.DES = i._createHelper(h);
                var p = r.TripleDES = i.extend({
                    _doReset: function() {
                        var e = this._key.words;
                        this._des1 = h.createEncryptor(n.create(e.slice(0, 2))),
                        this._des2 = h.createEncryptor(n.create(e.slice(2, 4))),
                        this._des3 = h.createEncryptor(n.create(e.slice(4, 6)))
                    },
                    encryptBlock: function(e, t) {
                        this._des1.encryptBlock(e, t),
                        this._des2.decryptBlock(e, t),
                        this._des3.encryptBlock(e, t)
                    },
                    decryptBlock: function(e, t) {
                        this._des3.decryptBlock(e, t),
                        this._des2.encryptBlock(e, t),
                        this._des1.decryptBlock(e, t)
                    },
                    keySize: 6,
                    ivSize: 2,
                    blockSize: 2
                });
                t.TripleDES = i._createHelper(p)
            }(),
            e.TripleDES
        }
        ,
        "object" == typeof o ? t.exports = o = n(e("./core"), e("./enc-base64"), e("./md5"), e("./evpkdf"), e("./cipher-core")) : "function" == typeof define && define.amd ? define(["./core", "./enc-base64", "./md5", "./evpkdf", "./cipher-core"], n) : n((void 0).CryptoJS),
        cc._RF.pop()
    }
    , {
        "./cipher-core": "cipher-core",
        "./core": "core",
        "./enc-base64": "enc-base64",
        "./evpkdf": "evpkdf",
        "./md5": "md5"
    }],
    "x64-core": [function(e, t, o) {
        "use strict";
        var n;
        cc._RF.push(t, "00569OfXKBJDZjjsRUEdXWW", "x64-core"),
        n = function(e) {
            var t, o, n, i, r;
            return o = (t = e).lib,
            n = o.Base,
            i = o.WordArray,
            (r = t.x64 = {}).Word = n.extend({
                init: function(e, t) {
                    this.high = e,
                    this.low = t
                }
            }),
            r.WordArray = n.extend({
                init: function(e, t) {
                    e = this.words = e || [],
                    this.sigBytes = null != t ? t : 8 * e.length
                },
                toX32: function() {
                    for (var e = this.words, t = e.length, o = [], n = 0; n < t; n++) {
                        var r = e[n];
                        o.push(r.high),
                        o.push(r.low)
                    }
                    return i.create(o, this.sigBytes)
                },
                clone: function() {
                    for (var e = n.clone.call(this), t = e.words = this.words.slice(0), o = t.length, i = 0; i < o; i++)
                        t[i] = t[i].clone();
                    return e
                }
            }),
            e
        }
        ,
        "object" == typeof o ? t.exports = o = n(e("./core")) : "function" == typeof define && define.amd ? define(["./core"], n) : n((void 0).CryptoJS),
        cc._RF.pop()
    }
    , {
        "./core": "core"
    }]
}, {}, ["LevelMgr", "LogicMgr", "Main", "ScreenMgr", "SoundMgr", "BufferPool", "Func", "Interface", "MessageMgr", "SpecialFunc", "TimeOutInterval", "CountdownTime", "EditboxDisplay", "NodeHandle", "PageView", "SliderProgress", "Tip", "UIPicText", "GTAssembler2D", "GTAutoFitSpriteAssembler2D", "GTSimpleSpriteAssembler2D", "LangChange", "LayeredBatchingAssembler", "LayeredBatchingRootRenderer", "SceneParticlesBatching", "ScrollPgView", "DebugMgr", "EffectBase", "EffectCfg", "EffectMgr", "EffectShake", "EEvent", "GameNet", "GameProto", "NetMgr", "BsLangText", "DyncAnimPlay", "DyncInfo", "DyncLoadedBase", "DyncMgr", "LanguageMgr", "ParticlePlay", "ResCfg", "TextDesc", "Effect_Circular_Bead", "Effect_Dibble", "LabelShader1", "NoColorSprite", "aes", "cipher-core", "core", "crypto-js", "enc-base64", "enc-hex", "enc-latin1", "enc-utf16", "enc-utf8", "evpkdf", "format-hex", "format-openssl", "hmac-md5", "hmac-ripemd160", "hmac-sha1", "hmac-sha224", "hmac-sha256", "hmac-sha3", "hmac-sha384", "hmac-sha512", "hmac", "index", "lib-typedarrays", "md5", "mode-cfb", "mode-ctr-gladman", "mode-ctr", "mode-ecb", "mode-ofb", "pad-ansix923", "pad-iso10126", "pad-iso97971", "pad-nopadding", "pad-pkcs7", "pad-zeropadding", "pbkdf2", "rabbit-legacy", "rabbit", "rc4", "ripemd160", "sha1", "sha224", "sha256", "sha3", "sha384", "sha512", "tripledes", "x64-core", "Config", "MutabEffectCfg", "MutabResCfg", "MutabTextDesc", "AdvertUI", "BigAdvertUI", "CardUI", "CashbackUI", "CustomScrollView", "HallUI", "HeadUI", "JpRankUI", "JpUI", "KeyboardUI", "LoginUI", "ModPwdBox", "MsgPromptBox", "Notice", "NoticeTip", "PcFullScreenUI", "ReconnectTip", "RollPrize", "SettingBox", "ShareUI"]);
