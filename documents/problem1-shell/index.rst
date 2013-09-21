.. problem1-shell documentation master file, created by
   sphinx-quickstart on Sat Sep 21 19:47:09 2013.
   You can adapt this file completely to your liking, but it should at least
   contain the root `toctree` directive.

培训题1 shell程序报告
======================

严春伟          yanchunwei@baidu.com
----------------------------------------

算法
----
题中需要求每个domain的子站的平均url个数，然后在此基础上筛选出高于平均水平的子站url。 分成两个步骤，第一步为统计，第二步进行筛选输出。 

在统计阶段，最本质的要求是找出all.site中每个子站url对应的domain，具体实现中，有两种思路，分别为:

1. 字典方法
2. 排序方法

下面具体阐述。 

字典方法
^^^^^^^^^^^
利用awk对 *all.domain* 的每个domain建立字典，然后在 *all.site* 中进行domain的匹配。

原理
""""""""

字典可以直接利用awk的关联数组实现，而site url与其domain的匹配过程分为 *拆分* 和 *贪心匹配* ，具体如下：

1. 拆分阶段，以'.'拆分site's url为多个部分
2. 贪心匹配阶段，从头往后扫描，用'.'连接直到尾，尝试组合成最大长度的新url去查询字典，如果命中，则输出为此site url的domain

例如：

建立的字典如下：

1. baidu.com
2. site.baidu.com

all.site中有 *1.music.baidu.com* 需要匹配出其domain. 则依次进行如下过程：

#. 对 "music.baidu.com" 拆分为如下部分： "1" "music" "baidu" "com"
#. 从头部开始扫描，尝试用各种新的url组合去命中字典
    #. 1.music.baidu.com 不命中
    #. music.baidu.com 不命中
    #. baidu.com 命中，输出为domain

具体算法
""""""""
以下以python风格的伪代码给出

.. code-block:: python
    :linenos:

    # 字典 记录每个domain的所有子站的数目
    domain = {}
    # 字典 记录每个domain的子站个数
    n_sites = {}

    for d in all.domain:
        domain[d] = 0
        n_sites[d] = 0

    for url,num in all.site:
        _domain = get_domain(url)
        domain[_domain] += num
        n_sites[_domain] += 1

    # 计算每个domian的子站平均url个数
    for key in domain:
        domain[key]  /= n_sites[key]

    for url,num in all.site:
        _domain = get_domain(url)
        ave_num = domain[_domain]

        if num > ave_num:
            # 输出信息
            output url, num, _domain
        

        

    

具体实现
"""""""""

复杂度分析
"""""""""""""

实验结果
"""""""""

排序方法
^^^^^^^^
原理
""""""""
考虑到domain必然是其子站点url从后往前匹配的一部分，方法的大体思想是，将all.domain和all.site中的url逆转一下，加入原文件中作为第一个field，然后混合起来对第一个field排序，最终肯定会出现一个domain后接其所有子站点url的状态。
对排序结果进行统计，就能够得到需要的各种信息。

比如：
有domain: *baidu.com* ， 同时有若干对应子站点url："music.baidu.com 567" "map.baidu.com 345"

2. url逆转，得到混合文件：

+---------------+----------------------+---------------+
|moc.udiab      |baidu.com             |               |
+---------------+----------------------+---------------+
|moc.udiab.cisum|music.baidu.com       |567            |
+---------------+----------------------+---------------+
|moc.udiab.pam  |map.baidu.com         |345            |
+---------------+----------------------+---------------+
	

2. 扫描排序结果，统计并输出

具体算法
""""""""
以下以python风格的伪代码给出

.. code-block:: python
    :linenos:

    for line in all.domain + all.site:
        inv_url = inverse(get_first_field(line))
        line = inv_url + '\t' + line
        output line > combined.urls

    sort_by_first_field combined.urls > combined.urls

    domain = 0
    sites = []
    
    # 对每个domain及其后接的子站url列表区域解析并统计
    for line in combined.urls:
        ls = line.split('\t')

        if len(ls) == 1:
            # 处理上次记录的domain及其子站点列表
            if sites:
                ave_num = domain/len(sites)
                for site in sites:
                    num = int(site[2])
                    if num > ave_num:
                        ouput site[1:]
            # 重置状态
            domain = 0
            sites = []
        else:
            num = int(ls[2])
            domain += num
            sites.append(ls)

    if sites:
        ave_num = domain/len(sites)
        for url in sites:
            num = int(site[2])
            if num > ave_num:
                ouput site[1:]

具体实现
"""""""""

复杂度分析
"""""""""""""

实验结果
"""""""""

Indices and tables
==================

* :ref:`genindex`
* :ref:`modindex`
* :ref:`search`

