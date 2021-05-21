(window.webpackJsonp=window.webpackJsonp||[]).push([[8],{361:function(s,a,t){"use strict";t.r(a);var n=t(41),e=Object(n.a)({},(function(){var s=this,a=s.$createElement,t=s._self._c||a;return t("ContentSlotsDistributor",{attrs:{"slot-key":s.$parent.slotKey}},[t("h1",{attrs:{id:"环境配置"}},[t("a",{staticClass:"header-anchor",attrs:{href:"#环境配置"}},[s._v("#")]),s._v(" 环境配置")]),s._v(" "),t("h2",{attrs:{id:"写在前面"}},[t("a",{staticClass:"header-anchor",attrs:{href:"#写在前面"}},[s._v("#")]),s._v(" 写在前面")]),s._v(" "),t("blockquote",[t("p",[s._v("本次部署基于部署人员熟悉springboot与vue的打包，下次有空再将对应的前后端打包成镜像，使用docker一键部署就比较方便\n"),t("strong",[s._v('但目前只能"享受"一步步部署的乐趣')])])]),s._v(" "),t("h2",{attrs:{id:"环境说明"}},[t("a",{staticClass:"header-anchor",attrs:{href:"#环境说明"}},[s._v("#")]),s._v(" 环境说明")]),s._v(" "),t("ul",[t("li",[s._v("后端：需要在Linux系统下部署运行，建议使用ubuntu18.04，其它版本的Linux系统也可，同时需要"),t("strong",[s._v("Docker")]),s._v("辅助部署")]),s._v(" "),t("li",[s._v("前端：Linux系统下，需要nginx进行反向代理")]),s._v(" "),t("li",[s._v("判题服务：由于判题沙盒有多操作系统版本，Linux系统或Windows都可，强烈建议Linux系统（Ubuntu）")]),s._v(" "),t("li",[s._v("数据同步：需要运行判题服务和后端服务的服务器有rsync即可")])]),s._v(" "),t("h2",{attrs:{id:"linux服务器环境搭建"}},[t("a",{staticClass:"header-anchor",attrs:{href:"#linux服务器环境搭建"}},[s._v("#")]),s._v(" Linux服务器环境搭建")]),s._v(" "),t("blockquote",[t("p",[s._v("请先准备一台 CPU: 1核 内存: 2G 硬盘: 30G的云服务器，推荐Ubuntu16.04以上的操作系统，")]),s._v(" "),t("p",[s._v("HOJ使用的Ubuntu18.04版本")])]),s._v(" "),t("h3",{attrs:{id:"安装nginx"}},[t("a",{staticClass:"header-anchor",attrs:{href:"#安装nginx"}},[s._v("#")]),s._v(" 安装nginx")]),s._v(" "),t("blockquote",[t("p",[s._v("注意：apt下载太慢的话，建议换阿里云源，请自行百度or谷歌")])]),s._v(" "),t("ol",[t("li",[t("p",[s._v("使用apt安装")]),s._v(" "),t("div",{staticClass:"language-shell line-numbers-mode"},[t("pre",{pre:!0,attrs:{class:"language-shell"}},[t("code",[t("span",{pre:!0,attrs:{class:"token function"}},[s._v("sudo")]),s._v(" "),t("span",{pre:!0,attrs:{class:"token function"}},[s._v("apt")]),s._v(" "),t("span",{pre:!0,attrs:{class:"token function"}},[s._v("install")]),s._v(" nginx\n")])]),s._v(" "),t("div",{staticClass:"line-numbers-wrapper"},[t("span",{staticClass:"line-number"},[s._v("1")]),t("br")])])]),s._v(" "),t("li",[t("p",[s._v("路径介绍")]),s._v(" "),t("ul",[t("li",[s._v("/usr/sbin/nginx：主程序")]),s._v(" "),t("li",[s._v("/etc/nginx：存放配置文件")]),s._v(" "),t("li",[s._v("/usr/share/nginx：存放静态文件")]),s._v(" "),t("li",[s._v("/var/log/nginx：存放日志")])])]),s._v(" "),t("li",[t("p",[s._v("启动nginx")]),s._v(" "),t("div",{staticClass:"language-shell line-numbers-mode"},[t("pre",{pre:!0,attrs:{class:"language-shell"}},[t("code",[t("span",{pre:!0,attrs:{class:"token function"}},[s._v("service")]),s._v(" nginx start\n")])]),s._v(" "),t("div",{staticClass:"line-numbers-wrapper"},[t("span",{staticClass:"line-number"},[s._v("1")]),t("br")])])]),s._v(" "),t("li",[t("p",[s._v("验证是否成功")]),s._v(" "),t("p",[s._v("在浏览器输入你的ip地址，如果出现Wellcome to nginx 那么就是配置成功。")])])]),s._v(" "),t("h3",{attrs:{id:"安装docker"}},[t("a",{staticClass:"header-anchor",attrs:{href:"#安装docker"}},[s._v("#")]),s._v(" 安装docker")]),s._v(" "),t("ol",[t("li",[t("p",[s._v("安装需要的包")]),s._v(" "),t("div",{staticClass:"language-shell line-numbers-mode"},[t("pre",{pre:!0,attrs:{class:"language-shell"}},[t("code",[t("span",{pre:!0,attrs:{class:"token function"}},[s._v("sudo")]),s._v(" "),t("span",{pre:!0,attrs:{class:"token function"}},[s._v("apt-get")]),s._v(" update\n")])]),s._v(" "),t("div",{staticClass:"line-numbers-wrapper"},[t("span",{staticClass:"line-number"},[s._v("1")]),t("br")])])]),s._v(" "),t("li",[t("p",[s._v("安装依赖包")]),s._v(" "),t("div",{staticClass:"language-shell line-numbers-mode"},[t("pre",{pre:!0,attrs:{class:"language-shell"}},[t("code",[t("span",{pre:!0,attrs:{class:"token function"}},[s._v("sudo")]),s._v(" "),t("span",{pre:!0,attrs:{class:"token function"}},[s._v("apt-get")]),s._v(" "),t("span",{pre:!0,attrs:{class:"token function"}},[s._v("install")]),s._v(" "),t("span",{pre:!0,attrs:{class:"token punctuation"}},[s._v("\\")]),s._v("\n   apt-transport-https "),t("span",{pre:!0,attrs:{class:"token punctuation"}},[s._v("\\")]),s._v("\n   ca-certificates "),t("span",{pre:!0,attrs:{class:"token punctuation"}},[s._v("\\")]),s._v("\n   "),t("span",{pre:!0,attrs:{class:"token function"}},[s._v("curl")]),s._v(" "),t("span",{pre:!0,attrs:{class:"token punctuation"}},[s._v("\\")]),s._v("\n   gnupg-agent "),t("span",{pre:!0,attrs:{class:"token punctuation"}},[s._v("\\")]),s._v("\n   software-properties-common\n")])]),s._v(" "),t("div",{staticClass:"line-numbers-wrapper"},[t("span",{staticClass:"line-number"},[s._v("1")]),t("br"),t("span",{staticClass:"line-number"},[s._v("2")]),t("br"),t("span",{staticClass:"line-number"},[s._v("3")]),t("br"),t("span",{staticClass:"line-number"},[s._v("4")]),t("br"),t("span",{staticClass:"line-number"},[s._v("5")]),t("br"),t("span",{staticClass:"line-number"},[s._v("6")]),t("br")])])]),s._v(" "),t("li",[t("p",[s._v("添加 Docker 的官方 GPG 密钥")]),s._v(" "),t("div",{staticClass:"language-shell line-numbers-mode"},[t("pre",{pre:!0,attrs:{class:"language-shell"}},[t("code",[t("span",{pre:!0,attrs:{class:"token function"}},[s._v("curl")]),s._v(" -fsSL https://download.docker.com/linux/ubuntu/gpg "),t("span",{pre:!0,attrs:{class:"token operator"}},[s._v("|")]),s._v(" "),t("span",{pre:!0,attrs:{class:"token function"}},[s._v("sudo")]),s._v(" apt-key "),t("span",{pre:!0,attrs:{class:"token function"}},[s._v("add")]),s._v(" -\n")])]),s._v(" "),t("div",{staticClass:"line-numbers-wrapper"},[t("span",{staticClass:"line-number"},[s._v("1")]),t("br")])])]),s._v(" "),t("li",[t("p",[s._v("设置远程仓库")]),s._v(" "),t("div",{staticClass:"language-shell line-numbers-mode"},[t("pre",{pre:!0,attrs:{class:"language-shell"}},[t("code",[t("span",{pre:!0,attrs:{class:"token function"}},[s._v("sudo")]),s._v(" add-apt-repository "),t("span",{pre:!0,attrs:{class:"token punctuation"}},[s._v("\\")]),s._v("\n   "),t("span",{pre:!0,attrs:{class:"token string"}},[s._v('"deb [arch=amd64] https://download.docker.com/linux/ubuntu \\\n  '),t("span",{pre:!0,attrs:{class:"token variable"}},[t("span",{pre:!0,attrs:{class:"token variable"}},[s._v("$(")]),s._v("lsb_release -cs"),t("span",{pre:!0,attrs:{class:"token variable"}},[s._v(")")])]),s._v(' \\\n  stable"')]),s._v("\n")])]),s._v(" "),t("div",{staticClass:"line-numbers-wrapper"},[t("span",{staticClass:"line-number"},[s._v("1")]),t("br"),t("span",{staticClass:"line-number"},[s._v("2")]),t("br"),t("span",{staticClass:"line-number"},[s._v("3")]),t("br"),t("span",{staticClass:"line-number"},[s._v("4")]),t("br")])])]),s._v(" "),t("li",[t("p",[s._v("安装 Docker-CE")]),s._v(" "),t("div",{staticClass:"language-shell line-numbers-mode"},[t("pre",{pre:!0,attrs:{class:"language-shell"}},[t("code",[t("span",{pre:!0,attrs:{class:"token function"}},[s._v("sudo")]),s._v(" "),t("span",{pre:!0,attrs:{class:"token function"}},[s._v("apt-get")]),s._v(" update\n"),t("span",{pre:!0,attrs:{class:"token function"}},[s._v("sudo")]),s._v(" "),t("span",{pre:!0,attrs:{class:"token function"}},[s._v("apt-get")]),s._v(" "),t("span",{pre:!0,attrs:{class:"token function"}},[s._v("install")]),s._v(" docker-ce docker-ce-cli containerd.io\n")])]),s._v(" "),t("div",{staticClass:"line-numbers-wrapper"},[t("span",{staticClass:"line-number"},[s._v("1")]),t("br"),t("span",{staticClass:"line-number"},[s._v("2")]),t("br")])])]),s._v(" "),t("li",[t("p",[s._v("验证是否成功")]),s._v(" "),t("div",{staticClass:"language-shell line-numbers-mode"},[t("pre",{pre:!0,attrs:{class:"language-shell"}},[t("code",[t("span",{pre:!0,attrs:{class:"token function"}},[s._v("sudo")]),s._v(" docker run hello-world\n")])]),s._v(" "),t("div",{staticClass:"line-numbers-wrapper"},[t("span",{staticClass:"line-number"},[s._v("1")]),t("br")])])])])])}),[],!1,null,null,null);a.default=e.exports}}]);