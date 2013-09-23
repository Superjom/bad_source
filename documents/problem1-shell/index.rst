.. problem1-shell documentation master file, created by
   sphinx-quickstart on Sat Sep 21 19:47:09 2013.
   You can adapt this file completely to your liking, but it should at least
   contain the root `toctree` directive.

======================
培训题1 shell程序报告
======================

严春伟          yanchunwei@baidu.com
----------------------------------------

1. 算法
##########
题中需要求每个domain的子站的平均url个数，然后在此基础上筛选出高于平均水平的子站url。 分成两个步骤，第一步为统计，第二步进行筛选输出。 

在统计阶段，最本质的要求是找出all.site中每个子站url对应的domain，具体实现中，有两种思路，分别为:

1. 字典方法
2. 排序方法

下面具体阐述。 

1.1 字典方法
*************
利用awk对 *all.domain* 的每个domain建立字典，然后在 *all.site* 中进行domain的匹配。

原理
========

字典可以直接利用awk的关联数组实现，而site url与其domain的匹配过程分为 *拆分* 和 *贪心匹配* ，具体如下：

1. 拆分阶段，以'.'拆分site's url为多个部分
2. 贪心匹配阶段，从头往后扫描，用'.'连接直到尾，尝试组合成最大长度的新url去查询字典，如果命中，则输出为此site url的domain

例如：

建立的字典如下：

1. baidu.com
2. site.baidu.com

all.site中有 *1.music.baidu.com* 需要匹配出其domain. 则依次进行如下过程：

#. 对 "1.music.baidu.com" 拆分为如下部分： "1" "music" "baidu" "com"
#. 从头部开始扫描，尝试用各种新的url组合去命中字典
    #. 1.music.baidu.com 不命中
    #. music.baidu.com 不命中
    #. baidu.com 命中，输出为domain

具体算法
========
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
========
代码位于 *chunwei/buff.sh* 和 *chunwei/buff_split.sh* 中，前者为不优化版本，后者为经过拆分优化的版本。

前者输出位于 *chunwei/data/output.no_split* ，后者位于 *chunwei/data/output.final* 中。

输出的每行依次为:

* site's url
* domain
* site's count 
* domain's average count

优化
========
优化主要从内存或者速度方面进行的修改。 *chunwei/buff.sh* 运行时内存到1.2G，时间到3m48s，于是，想到利用拆分文件的方式进行优化，当原始文件拆分为小文件后，就可以很方便地进行优化：

* 加速： 多进程并行处理多个分块
* 减少内存：每次处理1个或少量分块

**拆分文件方法** ：

最简单的拆分方式就是根据 *all.domain* 和 *all.site* 中包含的url进行拆分。
为了能够将site's url 及其对应的domain分配到同一个文件，不能简单按照首字母进行拆分。
考虑到site's domain必然是site's url从尾向前的一部分，而每个domain必然都至少有两个域，具体做法是： 按照url的倒数第二个field的首字母进行拆分。

例如：

* baidu.com
* music.baidu.com  
按照第2个field： *baidu* 的首字母 *b* 均能被分配到同一个文件 *split.b* 中。


复杂度分析
=================
假设，all.domain长度为 :math:`n_1` , all.site长度为 :math:`n_2` ,其中 :math:`N=n_1 + n_2` 。

字典方法需要三次扫描，总复杂度为 :math:`O(N)`.

拆分的影响
""""""""""""
拆分s块后的复杂度不变:

.. math::
    
    O(s * \frac{N}{s}) = O(N)

步骤分析
""""""""""""
#. 分别拆分 all.domain, all.site , :math:`O(N)`
#. 扫描 all.domain 建立全局字典: :math:`O(n_1)`
#. 统计 all.site 计算每个domain的平均值 :math:`O(n_2)`
#. 扫描 all.site 输出筛选出的item :math:`O(n_2)`

总体上是 :math:`O(N)` 的复杂度。


实验结果
=========

最终输出实例:
""""""""""""""

.. image:: images/dic_output.png


未优化版本 
""""""""""""
*chunwei/buff.sh*

时间

.. image:: images/dic_no_split.png

内存消耗

< 1.2G

并行优化版本 
""""""""""""
*chunwei/buff_split.sh* 
运行 main函数

同时开启了5个进程，并行处理拆分的38个分块

时间

.. image:: images/dic_split_multi.png

内存消耗： <= 800M 

内存优化版本 
"""""""""""""""
*chunwei/buff_split.sh*
运行 main函数

共拆分38个分块，同时只对一个分块进行处理。



1.2 排序方法
*************
原理
===========
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
===========
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
===========
代码位于 *chunwei/buff_sort.sh* 中，输出位于 *chunwei/data1/ouput.final* 中。

输出格式与 *字典方法* 一致。

复杂度分析
===========
排序方法总的复杂度是 :math:`O(N\log{N})`. 

步骤分析
"""""""""""
#. 拆分文件， :math:`O(N)`
#. 排序，   :math:`O(N\log{N})`
#. 统计， :math:`O(N)`

因此，总的复杂度为 :math:`O(N\log{N})`

拆分的影响
""""""""""""
类似于字典方法，对于 :math:`O(N)` 的步骤，拆分对效率没有影响。

下面讨论拆分成 :math:`s` 小块对排序步骤的影响:

.. math::
    
    TIME = s \times \frac{N}{s} \log{\frac{N}{s}}
    
    = N(\log{N} - \log{s})

    improve: \frac{TIME}{N\log{N}} = 1 - \frac{\log{s}}{\log{N}}

:math:`\frac{\log{s}}{\log{N}}` 是一个不可忽略的优化值，比如，all.site 和 all.domain共 18000000 条记录，拆分为32份后的优化为 

.. math::

    \frac{\log{32}}{\log{18000000}} = 0.2

因此，拆分对于排序的效率是有一定提高的。



实验结果
===========
输出演示：

.. image:: images/sort_output.png


与字典并行版本一致，拆分为38个子块，同时采用5个进程。

时间：

.. image:: images/sort_buff.png

内存占用基本与分块大小一致，< 120M


2. 两种方法对比和总结
*********************
字典方法能够在 :math:`O(n)` 时间排序，比排序方法的 :math:`O(N\log{N})` 复杂度要低，在实际运行时间也证实字典方法更快。 

但实现方法不同，通过 awk 的关系数组维护的字典方法必须维持一个相当于 all.domain 大小的全局字典，而sort方法需要载入整个文件才能有效运行，两种方法在脚本不作优化实现后都占用了比文件本身多得多的内存，达到了1.2G+。

通过拆分之后，两种方法都有效地降低了内存消耗，通过并行多进程运行，两种方法均提高了运行速度，其中字典方法的最终效果最好，达到的800M-的内存消耗，及1m45s的运行速度。

3. 后期改进
****************
在具体实现中，为了方便调试，产生了很多中间产物，可能占用一部分磁盘，另外产物文件目录较乱，后期尽量用管道的方法简化产物的传递。 

排序方法和字典方法的认识并不深刻，包括两者优缺点及适用环境。后期可以多多挖掘两者的优缺点。 同时对两者的脚本在实际环境中占用比文件本身几倍的内存，需要更多的分析和优化。 
