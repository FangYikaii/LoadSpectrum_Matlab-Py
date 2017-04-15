#!/usr/bin/python
# -*- coding: utf-8 -*-
__author__ = "FangYikaii"
__version__ = "v1.0"

import Tkinter as tk   # gui
import UI_PyTkinter as pytk  # 自定义画图
import UI_Adaptive  # 适配画图
import xlrd  # excel
import MySQLdb  # mysql
import tkMessageBox  # messagebox
import tkFileDialog  # filedialog
from PIL import Image, ImageTk  # 图片处理
import sys # 系统
import string # 字符串
from matplotlib.figure import Figure
from matplotlib.backends.backend_tkagg import FigureCanvasTkAgg
import numpy as np
import MySQLdb.cursors
#import ch
#ch.set_ch()

# 初始值
g_font = UI_Adaptive.monaco_font
g_size_dict = UI_Adaptive.size_dict
g_default_theme = pytk.g_default_theme
enty_width = 30

reload(sys)
sys.setdefaultencoding( "utf-8" )

# 登录
class Login(object):
    # 初始化
    def __init__(self, login=None):
        """Constructor"""
        self.root = login
        self.frm = pytk.PyLabelFrame(self.root)
        self.root.title("数据管理平台")
        self.frm.grid(row=0, column=0, sticky="wesn")

        self.frm_title = pytk.PyLabelFrame(self.frm)
        self.frm_mysql = pytk.PyLabelFrame(self.frm)
        self.frm_title.grid(row=0, padx=50, pady=20, sticky="wesn")
        self.frm_mysql.grid(row=1, column=0, padx=20, pady=20, sticky="wesn")

        self.frm_title.grid(row=0, padx=10, pady=20, sticky="wesn")
        self.frm_mysql.grid(row=1, column=0, padx=70, pady=20, sticky="wesn")
        self.create_frm_title()
        self.create_frm_mysql()

    # 标题
    def create_frm_title(self):
        self.frm_title_label = pytk.PyLabel(self.frm_title,
                                            text="IDEAL数据管理平台",
                                            font=("Times", 30))
        self.frm_title_label.grid(row=0, column=0, padx=20, sticky="wsne")

    # 框架mysql
    def create_frm_mysql(self):
        self.frm_left_mysql_label = pytk.PyLabel(self.frm_mysql,
                                                 text="Mysql Connect",
                                                 font=("Times", 25))
        self.frm_left_mysql_ipfrm = pytk.PyLabelFrame(self.frm_mysql)
        self.frm_left_mysql_namefrm = pytk.PyLabelFrame(self.frm_mysql)
        self.frm_left_mysql_passwordfrm = pytk.PyLabelFrame(self.frm_mysql)
        self.frm_left_mysql_btncon = pytk.PyButton(self.frm_mysql,
                                                   text="Mysql连接",
                                                   font=g_font,
                                                   command=self.mysql_connect)
        self.frm_left_mysql_btnquit = pytk.PyButton(self.frm_mysql,
                                                   text="退出登录",
                                                   font=g_font,
                                                   command=self.frm.quit)
        self.frm_left_mysql_label.grid(row=0, column=0, sticky="wsne")
        self.frm_left_mysql_ipfrm.grid(row=1, column=0, sticky="wsne")
        self.frm_left_mysql_namefrm.grid(row=2, column=0, sticky="wsne")
        self.frm_left_mysql_passwordfrm.grid(row=3, column=0, sticky="wsne")
        self.frm_left_mysql_btncon.grid(row=4, column=0, pady=10, padx=70, sticky="wsne")
        self.frm_left_mysql_btnquit.grid(row=5, column=0, pady=10, padx=70, sticky="wsne")
        var1 = tk.StringVar()
        var1.set("localhost")
        self.frm_left_mysql_ipfrm_label = pytk.PyLabel(self.frm_left_mysql_ipfrm, text="ip地址：", font=("Times", 15))
        self.frm_left_mysql_ipfrm_entry = pytk.PyEntry(self.frm_left_mysql_ipfrm, textvariable=var1, font=("Times", 15),
                                                       width=enty_width)
        self.frm_left_mysql_ipfrm_label.grid(row=0, column=0, sticky="w")
        self.frm_left_mysql_ipfrm_entry.grid(row=1, column=0, sticky="w")
        var2 = tk.StringVar()
        var2.set("root")
        self.frm_left_mysql_namefrm_label = pytk.PyLabel(self.frm_left_mysql_namefrm, text="用户名：", font=("Times", 15))
        self.frm_left_mysql_namefrm_entry = pytk.PyEntry(self.frm_left_mysql_namefrm, font=("Times", 15),
                                                         textvariable=var2, width=enty_width)
        self.frm_left_mysql_namefrm_label.grid(row=0, column=0, sticky="w")
        self.frm_left_mysql_namefrm_entry.grid(row=1, column=0, sticky="w")
        var3 = tk.StringVar()
        var3.set("fykfyk")
        self.frm_left_mysql_passwordfrm_label = pytk.PyLabel(self.frm_left_mysql_passwordfrm, text="密码：",
                                                             font=("Times", 15))
        self.frm_left_mysql_passwordfrm_entry = pytk.PyEntry(self.frm_left_mysql_passwordfrm, font=("Times", 15),
                                                             textvariable=var3, width=enty_width)
        self.frm_left_mysql_passwordfrm_label.grid(row=0, column=0, sticky="w")
        self.frm_left_mysql_passwordfrm_entry.grid(row=1, column=0, sticky="w")
        self.frm_left_mysql_passwordfrm_entry.configure(show='*')

    # Mysql连接
    def mysql_connect(self):
        global conn  # Mysql连接
        ip = self.frm_left_mysql_ipfrm_entry.get()
        name = self.frm_left_mysql_namefrm_entry.get()
        password = self.frm_left_mysql_passwordfrm_entry.get()
        try:
            conn = MySQLdb.connect(host=ip, user=name, passwd=password, port=3306, charset='utf8',
                                   cursorclass=MySQLdb.cursors.DictCursor)
            self.root.withdraw()
            MainWindow(self)
        except MySQLdb.Error, e:
            tkMessageBox.showinfo("登录错误", u"%d:%s" % (e.args[0], e.args[1]))

# 主菜单
class MainWindow(tk.Toplevel):
    # 初始化
    def __init__(self, mainwindow=None):
        tk.Toplevel.__init__(self)
        self.original_frame = mainwindow
        self.resizable(False, False)
        self.title("IDEAL数据管理平台")
        self.create_frame()

    # 整体框架
    def create_frame(self):
        self.frm = pytk.PyLabelFrame(self)
        self.frm.grid(row=0, column=0, sticky="wesn")
        # 标题，按钮
        self.frm_title = pytk.PyLabelFrame(self.frm)
        self.frm_button=pytk.PyLabelFrame(self.frm)
        self.frm_title.grid(row=0, padx=30, pady=20, sticky="wesn")
        self.frm_button.grid(row=1, column=0, padx=20, pady=20, sticky="wesn")
        # 2组按钮
        self.frm_car = pytk.PyLabelFrame(self.frm_button)
        self.frm_spectrum = pytk.PyLabelFrame(self.frm_button)
        self.frm_quit = pytk.PyLabelFrame(self.frm)

        self.frm_title.grid(row=0, padx=50, pady=50, sticky="wesn")
        self.frm_car.grid(row=1, column=0, padx=20, pady=20, sticky="wesn")
        self.frm_spectrum.grid(row=1, column=1, padx=20, pady=20, sticky="wesn")
        self.frm_quit.grid(row=2, column=0, padx=320, pady=20, sticky="wesn")

        self.create_frm_title()
        self.create_frm_car()
        self.create_frm_spectrum()
        self.create_frm_quit()

    # 标题
    def create_frm_title(self):
        # 以一个PIL图像对象打开
        pil_image = Image.open('pic//ideal.jpg')
        # 缩放图像让它保持比例，同时限制在一个矩形框范围内
        pil_image_resized = pil_image.resize((400, 80), Image.ANTIALIAS)
        tk_image = ImageTk.PhotoImage(pil_image_resized)
        self.frm_title_label = pytk.PyLabel(self.frm_title,
                                                 text="IDEAL数据管理平台",
                                                 font=("Times", 40))
        self.frm_pic = pytk.PyLabel(self.frm_title,image=tk_image)
        self.frm_title_label.grid(row=0, column=0, padx=50,sticky="wsne")
        self.frm_pic.grid(row=0,column=1,pady=20,padx=50,sticky="wesn")

    # 车辆参数
    def create_frm_car(self):
        self.frm_car_frame = pytk.PyLabelFrame(self.frm_car)
        self.frm_carimport_frame = pytk.PyLabelFrame(self.frm_car)
        self.frm_cardelete_frame = pytk.PyLabelFrame(self.frm_car)
        self.frm_carshow_frame = pytk.PyLabelFrame(self.frm_car)

        self.frm_car_frame.grid(row=0, column=0, sticky="wsne")
        self.frm_carimport_frame.grid(row=1, column=0, sticky="wsne")
        self.frm_cardelete_frame.grid(row=2, column=0,  sticky="wsne")
        self.frm_carshow_frame.grid(row=3, column=0, sticky="wsne")


        self.frm_car_label = pytk.PyLabel(self.frm_car_frame,
                                          text="车辆信息管理",
                                          font=("Times", 25))
        self.frm_carimport_btn = pytk.PyButton(self.frm_carimport_frame,
                                                   text="车辆信息导入",
                                                   font=("Times", 20),
                                                   command=self.openCarimport)
        self.frm_cardelete_btn = pytk.PyButton(self.frm_cardelete_frame,
                                         text="车辆信息删除",
                                         font=("Times", 20),
                                         command=self.openCardelete)
        self.frm_carshow_btn = pytk.PyButton(self.frm_carshow_frame,
                                         text="车辆信息管理",
                                         font=("Times", 20),
                                         command=self.openCarshow)
        self.frm_car_label.grid(row=0, column=0, padx=155,sticky="wsne")
        self.frm_carimport_btn.grid(row=0, column=0,  padx=170,sticky="wsne")
        self.frm_cardelete_btn.grid(row=0, column=0,  padx=170,sticky="wsne")
        self.frm_carshow_btn.grid(row=0, column=0,  padx=170,sticky="wsne")

    # 载荷谱
    def create_frm_spectrum(self):
        self.frm_spectrum_frame = pytk.PyLabelFrame(self.frm_spectrum)
        self.frm_spectrumimport_frame = pytk.PyLabelFrame(self.frm_spectrum)
        self.frm_spectrumdelete_frame = pytk.PyLabelFrame(self.frm_spectrum)
        self.frm_spectrumshow_frame = pytk.PyLabelFrame(self.frm_spectrum)

        self.frm_spectrum_frame.grid(row=0, column=0, sticky="wsne")
        self.frm_spectrumimport_frame.grid(row=1, column=0, sticky="wsne")
        self.frm_spectrumdelete_frame.grid(row=2, column=0, sticky="wsne")
        self.frm_spectrumshow_frame.grid(row=3, column=0, sticky="wsne")

        self.frm_spectrum_label = pytk.PyLabel(self.frm_spectrum_frame,
                                          text="载荷谱数据管理",
                                          font=("Times", 25))
        self.frm_spectrumimport_btn = pytk.PyButton(self.frm_spectrumimport_frame,
                                               text="载荷数据导入",
                                               font=("Times", 20),
                                               command=self.openSpectrumimport)
        self.frm_spectrumdelete_btn = pytk.PyButton(self.frm_spectrumdelete_frame,
                                               text="载荷数据删除",
                                               font=("Times", 20),
                                               command=self.openSpectrumdelete)
        self.frm_spectrumshow_btn = pytk.PyButton(self.frm_spectrumshow_frame,
                                             text="数据分析管理",
                                             font=("Times", 20),
                                             command=self.openSpectrumshow)
        self.frm_spectrum_label.grid(row=0, column=0,padx=155, sticky="wsne")
        self.frm_spectrumimport_btn.grid(row=0, column=0, padx=170, sticky="wsne")
        self.frm_spectrumdelete_btn.grid(row=0, column=0, padx=170, sticky="wsne")
        self.frm_spectrumshow_btn.grid(row=0, column=0, padx=170, sticky="wsne")

    # 退出程序
    def create_frm_quit(self):
        self.frm_left_mysql_btncon = pytk.PyButton(self.frm_quit,
                                                   text="退出应用程序",
                                                   font=("Times", 20),
                                                   command=self.frm.quit)
        self.frm_left_mysql_btncon.grid(row=0, column=0, padx=180, sticky="wsne")

    # 显示主窗体
    def show(self):
        self.update()
        self.deiconify()  # 显示窗口

    # 打开Carimport
    def openCarimport(self):
        self.withdraw()
        Loader_Import(self)

    # 打开Cardelete
    def openCardelete(self):
        self.withdraw()
        Loader_Delete(self)

    # 打开Carshow
    def openCarshow(self):
         self.withdraw()
         Loader_Show(self)

    # 打开Spectrumimport
    def openSpectrumimport(self):
        self.withdraw()
        Spectrum_Import(self)

    # 打开Spectrumdelete
    def openSpectrumdelete(self):
        self.withdraw()
        Spectrum_Delete(self)

    # 打开Spectrumshow
    def openSpectrumshow(self):
        self.withdraw()
        Spectrum_Show(self)


# 载荷谱数据导入
class Spectrum_Import(tk.Toplevel):
    # 初始化函数
    def __init__(self, master=None):
        tk.Toplevel.__init__(self)
        self.original_frame = master
        self.resizable(False, False)
        self.title("载荷谱数据导入")
        self.create_frame()
        self.mysql_connect()

    # 总体框架【上下】
    def create_frame(self):
        self.frm = pytk.PyLabelFrame(self)
        self.frm_status = pytk.PyLabelFrame(self)

        self.frm.grid(row=0, column=0, sticky="wesn")
        self.frm_status.grid(row=1, column=0, sticky="wesn")

        self.create_frm()
        self.create_frm_status()

    # 总体框架【左右】
    def create_frm(self):
        self.frm_right = pytk.PyLabelFrame(self.frm)
        self.frm_right.grid(row=0, column=1, padx=5, pady=5, sticky="wesn")
        self.create_frm_right()

    # 框架 右
    def create_frm_right(self):
        self.frm_right_spectrum_label = pytk.PyLabel(self.frm_right,
                                                     text="载荷谱类型参数",
                                                     font=("Times", 25))
        self.frm_right_spectrum_driver = pytk.PyLabelFrame(self.frm_right)
        self.frm_right_spectrum_object = pytk.PyLabelFrame(self.frm_right)
        self.frm_right_spectrum_power = pytk.PyLabelFrame(self.frm_right)
        self.frm_right_spectrum_mode = pytk.PyLabelFrame(self.frm_right)
        self.frm_right_spectrum_group = pytk.PyLabelFrame(self.frm_right)
        self.frm_right_spectrum_import = pytk.PyButton(self.frm_right,
                                                       text="载荷谱数据导入",
                                                       font=g_font,
                                                       command=self.btn_spectrum_import)
        self.frm_right_btn_back = pytk.PyButton(self.frm_right,
                                               text="返回主菜单",
                                               font=g_font,
                                               command=self.Back_main_menu)

        self.frm_right_spectrum_label.grid(row=0, column=0, sticky="wsne")
        self.frm_right_spectrum_driver.grid(row=1, column=0, sticky="wsne")
        self.frm_right_spectrum_object.grid(row=2, column=0, sticky="wsne")
        self.frm_right_spectrum_power.grid(row=3, column=0, sticky="wsne")
        self.frm_right_spectrum_mode.grid(row=4, column=0, sticky="wsne")
        self.frm_right_spectrum_group.grid(row=5, column=0, sticky="wsne")
        self.frm_right_spectrum_import.grid(row=6, column=0, pady=10, padx=70, sticky="wsne")
        self.frm_right_btn_back.grid(row=7, column=0, pady=10, padx=70, sticky="wesn")

        self.frm_right_spectrum_driver_label = pytk.PyLabel(self.frm_right_spectrum_driver, text="司机：",
                                                            font=("Times", 15))
        self.frm_right_spectrum_driver_entry = pytk.PyEntry(self.frm_right_spectrum_driver, width=enty_width,
                                                            font=("Times", 15))
        self.frm_right_spectrum_driver_label.grid(row=0, column=0, sticky="w")
        self.frm_right_spectrum_driver_entry.grid(row=1, column=0, sticky="w")

        self.frm_right_spectrum_object_label = pytk.PyLabel(self.frm_right_spectrum_object, text="作业对象：",
                                                            font=("Times", 15))
        self.frm_right_spectrum_object_entry = pytk.PyEntry(self.frm_right_spectrum_object, width=enty_width,
                                                            font=("Times", 15))
        self.frm_right_spectrum_object_label.grid(row=0, column=0, sticky="w")
        self.frm_right_spectrum_object_entry.grid(row=1, column=0, sticky="w")

        self.frm_right_spectrum_power_label = pytk.PyLabel(self.frm_right_spectrum_power, text="作业功率：",
                                                           font=("Times", 15))
        self.frm_right_spectrum_power_entry = pytk.PyEntry(self.frm_right_spectrum_power, width=enty_width,
                                                           font=("Times", 15))
        self.frm_right_spectrum_power_label.grid(row=0, column=0, sticky="w")
        self.frm_right_spectrum_power_entry.grid(row=1, column=0, sticky="w")

        self.frm_right_spectrum_group_label = pytk.PyLabel(self.frm_right_spectrum_group, text="实验组别：",
                                                           font=("Times", 15))
        self.frm_right_spectrum_group_entry = pytk.PyEntry(self.frm_right_spectrum_group, width=enty_width,
                                                           font=("Times", 15))
        self.frm_right_spectrum_group_label.grid(row=0, column=0, sticky="w")
        self.frm_right_spectrum_group_entry.grid(row=1, column=0, sticky="w")

        self.frm_right_spectrum_mode_label = pytk.PyLabel(self.frm_right_spectrum_mode, text="作业模式：",
                                                          font=("Times", 15))
        self.frm_right_spectrum_mode_entry = pytk.PyEntry(self.frm_right_spectrum_mode, width=enty_width,
                                                          font=("Times", 15))
        self.frm_right_spectrum_mode_label.grid(row=0, column=0, sticky="w")
        self.frm_right_spectrum_mode_entry.grid(row=1, column=0, sticky="w")

    # 框架 状态栏
    def create_frm_status(self):
        self.frm_status_label = pytk.PyLabel(self.frm_status,
                                             text="Mysql status：无",
                                             font=g_font)
        self.frm_status_label.grid(row=0, column=0, padx=5, pady=5, sticky="wesn")

    # 返回主菜单
    def Back_main_menu(self):
        self.destroy()
        MainWindow(self)

    # Mysql连接
    def mysql_connect(self):
        try:
            # 选择数据库
            conn.select_db('spectrumdb')
            self.frm_status_label["text"] = "Mysql status：数据库连接成功！"
        except MySQLdb.Error, e:
            tkMessageBox.showinfo("状态：", u"MySQL Error： %d:%s" % (e.args[0], e.args[1]))
            self.frm_status_label["text"] = u"MySQL Error： %d:%s" % (e.args[0], e.args[1])
            self.frm_status_label["text"] = "Mysql status：数据库连接失败！"

    # 载荷谱信息导入
    def btn_spectrum_import(self):
        try:
            # 游标
            cur = conn.cursor()
            # 插入Type表
            driver = self.frm_right_spectrum_driver_entry.get() # 司机
            mode = self.frm_right_spectrum_mode_entry.get()   # 模式
            power = self.frm_right_spectrum_power_entry.get() # 功率
            object = self.frm_right_spectrum_object_entry.get() # 作业对象
            groupx = self.frm_right_spectrum_group_entry.get()  # 组别
            # 判断字符串非空
            if driver and mode and power and object and groupx:
                #判断filename非空
                filename = tkFileDialog.askopenfilename(
                    filetypes=[("EXCEL file", "*.xlsx"), ("EXCEL file", "*.xls")])
                if filename:
                    # 插入类型
                    sql_type = "INSERT INTO spectrumtype (Driver,Modex,Power, Object, Groupx) VALUES('{0}','{1}','{2}','{3}','{4}') ".format(
                        driver, mode, power, object, groupx)
                    # 查重
                    sql_inquiry = "SELECT SpectrumtypeID FROM spectrumtype WHERE Driver = '{0}' AND Object = '{1}' AND Modex = '{2}' AND Power = '{3}' AND Groupx= '{4}'".format(
                        driver, object, mode, power, groupx)
                    # 删除重复的类型
                    sql_delete_type = "DELETE FROM spectrumtype WHERE Driver = '{0}' AND Object = '{1}' AND Modex = '{2}' AND Power = '{3}' AND Groupx= '{4}'".format(
                        driver, object, mode, power, groupx)
                    # 插入数据
                    sql_data = "insert into spectrumdata(SpectrumtypeID, Timex, PressureGZB, PressureDBDQ, PressureDBXQ, PressureZZX, PressureYZX, PressureZDDQ, PressureZDXQ, PressureZXB, PressureQJD, PressureHTD, PressureF1, PressureF2, PressureF3, PressureF4, PressureBSX, PressureQNJ, PressureHNJ, PressureBJQCK, PressureBJQJK, Acce1, Acce2, Acce3, SpeedWL, SpeedSCZ) values(%s ,%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)"
                    # 1.查重
                    cur.execute(sql_inquiry)
                    stus = cur.fetchall()  # tuple格式
                    # 2.如果重了
                    if stus:
                        for i in range(len(stus)):
                                # 3. 删除数据
                                sql_delete_data = "DELETE FROM spectrumdata WHERE SpectrumtypeID = '{0}'".format(
                                    stus[i]["SpectrumtypeID"])
                                cur.execute(sql_delete_data)
                                conn.commit()
                        # 4.删除重复类型
                        cur.execute(sql_delete_type)
                        conn.commit()
                    # 5.执行插入
                    cur.execute(sql_type)
                    conn.commit()
                    # 查询id
                    cur.execute(sql_inquiry)
                    stus = cur.fetchall()  # tuple格式

                    data = xlrd.open_workbook(filename)
                    table = data.sheets()[0]
                    nrows = table.nrows
                    tabledict = {}
                    for i in range(2, nrows):  # 第二列起读
                        tabledict[i] = table.row_values(i)
                        # 插入id
                        tabledict[i].insert(0, stus[0]["SpectrumtypeID"])
                    param01 = []
                    for i in range(2, nrows):  # 列表转元组，tabledict[i], 通过添加数据到列表中，然后再转为元组，因为元组是不可改的。
                        param01.append(tuple(tabledict[i]))
                    param02 = tuple(param01)
                    # 插入数据
                    cur.executemany(sql_data, param02)
                    conn.commit()
                    tkMessageBox.showinfo("提示", u"数据导入成功")
                    self.frm_status_label["text"] = "Mysql status：数据导入成功！"
                else:
                    tkMessageBox.showinfo("提示", u"请选择Excel表格！")
            else:
                tkMessageBox.showinfo("提示", u"请输入载荷谱类型信息！")
        except MySQLdb.Error, e:
            tkMessageBox.showinfo("Mysql错误", u"%d:%s" % (e.args[0], e.args[1]))

# 载荷谱数据删除
class Spectrum_Delete(tk.Toplevel):
    # 初始化函数
    def __init__(self, master=None):
        tk.Toplevel.__init__(self)
        self.original_frame = master
        self.resizable(False, False)
        self.title("载荷谱数据删除")
        self.create_frame()
        self.mysql_connect()

    # 总体框架【上下】
    def create_frame(self):
        self.frm = pytk.PyLabelFrame(self)
        self.frm_status = pytk.PyLabelFrame(self)

        self.frm.grid(row=0, column=0, sticky="wesn")
        self.frm_status.grid(row=1, column=0, sticky="wesn")

        self.create_frm()
        self.create_frm_status()

    # 总体框架【左右】
    def create_frm(self):
        self.frm_right = pytk.PyLabelFrame(self.frm)
        self.frm_right.grid(row=0, column=0, padx=5, pady=5, sticky="wesn")
        self.create_frm_right()

    # 框架 右
    def create_frm_right(self):
        self.frm_right_listbox = pytk.PyLabelFrame(self.frm_right)
        self.frm_right_listbox.grid(row=0, column=0, padx=20, pady=10, sticky="wesn")
        self.create_frm_right_listbox()

    # 列表
    def create_frm_right_listbox(self):
        self.frm_right_listbox_label = pytk.PyLabel(self.frm_right_listbox,
                                                         text="数据索引：",
                                                         font=("Times", 15))
        self.frm_right_listbox_data = pytk.PyListbox(self.frm_right_listbox, height=18,width=55, font=("Monaco", 15))
        self.frm_right_listbox_data.pack()
        self.frm_right_btn_back = pytk.PyButton(self.frm_right,
                                               text="返回主菜单",
                                               font=g_font,
                                               command=self.Back_main_menu)
        self.frm_right_btn_delete = pytk.PyButton(self.frm_right,
                                                  text="删除此条数据",
                                                  font=g_font,
                                                  command=self.btn_spectrum_delete)
        self.frm_right_listbox_label.grid(row=0, column=0, padx=0, pady=0, sticky="w")
        self.frm_right_listbox_data.grid(row=1, column=0, padx=0, pady=0, sticky="wesn")

        self.frm_right_btn_delete.grid(row=1, column=0,pady=10, padx=270, sticky="wsne")
        self.frm_right_btn_back.grid(row=2, column=0,pady=10, padx=270, sticky="wsne")

    # 框架 状态栏
    def create_frm_status(self):
        self.frm_status_label = pytk.PyLabel(self.frm_status,
                                             text="Mysql status：无",
                                             font=g_font)
        self.frm_status_label.grid(row=0, column=0, padx=5, pady=5, sticky="wesn")

    # 返回主菜单
    def Back_main_menu(self):
        self.destroy()
        MainWindow(self)

    # Mysql连接
    def mysql_connect(self):
        try:
            # 查询语句
            sql_inquery = "SELECT Driver, Modex, Object, Power, Groupx FROM spectrumtype"
            # 选择数据库
            conn.select_db('spectrumdb')
            # 游标，执行，返回stus
            cur = conn.cursor()
            cur.execute(sql_inquery)
            stus = cur.fetchall()
            # 提交
            conn.commit()
            # 关闭游标
            cur.close()
            # 显示
            self.frm_status_label["text"] = u"Mysql status：已连接到数据库spectrumdb！"
            nameall=[]
            if stus:
                for i in range(len(stus)):
                    name = "司机：" + str(stus[i]["Driver"]) + "作业模式：" + str(stus[i]["Modex"]) + "作业对象：" + str(stus[i]["Object"]) + "作业功率：" + str(stus[i]["Power"]) + "实验组别：" + str(stus[i]["Groupx"])
                    nameall.append(name)
                    self.frm_right_listbox_data.insert("end", nameall[i])
        except MySQLdb.Error, e:
            tkMessageBox.showinfo("状态：", u"MySQL Error： %d:%s" % (e.args[0], e.args[1]))
            self.frm_status_label["text"] = u"MySQL Error： %d:%s" % (e.args[0], e.args[1])
            self.frm_status_label["text"] = u"Mysql status：数据库连接失败！"

    # 载荷信息删除
    def btn_spectrum_delete(self):
        indexs = self.frm_right_listbox_data.curselection()
        indexs_data = indexs[0]
        sql_inquiry = "SELECT SpectrumtypeID FROM spectrumtype LIMIT {0}, 1".format(indexs_data)
        try:
            cur = conn.cursor()
            cur.execute(sql_inquiry)
            stus = cur.fetchall()  # tuple格式
            if stus:
                sql_delete_data = "DELETE FROM spectrumdata WHERE SpectrumtypeID = '{0}'".format(stus[0]["SpectrumtypeID"])
                cur.execute(sql_delete_data)
                conn.commit()
                sql_delete_type = "DELETE FROM spectrumtype WHERE SpectrumtypeID = '{0}'".format(stus[0]["SpectrumtypeID"])
                cur.execute(sql_delete_type)
                conn.commit()

            sql_inquery1 = "SELECT Driver, Modex, Object, Power, Groupx FROM spectrumtype"
            cur = conn.cursor()
            cur.execute(sql_inquery1)
            stus1 = cur.fetchall()
            nameall = []
            self.frm_status_label["text"] = u"Mysql status：数据库已更新！"
            self.frm_right_listbox_data.delete("0","end")
            if stus1:
                for i in range(len(stus1)):
                    name = "司机：" + str(stus1[i]["Driver"]) + "作业模式：" + str(stus1[i]["Modex"]) + "作业对象：" + str(stus1[i]["Object"]) + "作业功率：" + str(stus1[i]["Power"]) + "实验组别：" + str(stus1[i]["Groupx"])
                    nameall.append(name)
                    self.frm_right_listbox_data.insert("end", nameall[i])
        except MySQLdb.Error, e:
              tkMessageBox.showinfo("状态：", u"MySQL Error： %d:%s" % (e.args[0], e.args[1]))
              self.frm_status_label["text"] = u"MySQL Error： %d:%s" % (e.args[0], e.args[1])

# 载荷谱数据分析管理
class Spectrum_Show(tk.Toplevel):
    # 初始化函数
    def __init__(self, master=None):
        tk.Toplevel.__init__(self)
        self.original_frame = master
        self.resizable(False, False)
        self.title("数据分析管理")
        self.create_frame()
        self.mysql_connect()

    # 总体框架【上下】
    def create_frame(self):
        self.frm_up = pytk.PyLabelFrame(self)
        self.frm_status = pytk.PyLabelFrame(self)

        self.frm_up.grid(row=0, column=0, sticky="wesn")
        self.frm_status.grid(row=1, column=0, sticky="wesn")

        self.create_frm_up()
        self.create_frm_status()

    # 框架【上】
    def create_frm_up(self):
        self.frm_btn = pytk.PyLabelFrame(self.frm_up)
        self.frm_btn.grid(row=0, column=0, padx=20, pady=10, sticky="wesn")
        self.create_frm_left_mysql()

    # 框架
    def create_frm_left_mysql(self):
        self.frm_btn_back = pytk.PyButton(self.frm_btn,
                                               text="返回主菜单",
                                               font=('Monaco', 20),
                                               command=self.Back_main_menu)
        self.frm_btn_horizon = pytk.PyButton(self.frm_btn,
                                             text="数据可视化（横向）",
                                             font=('Monaco', 20),
                                             command=self.Show_horizon)
        self.frm_btn_vertical = pytk.PyButton(self.frm_btn,
                                              text="数据可视化（纵向）",
                                              font=('Monaco', 20),
                                              command=self.Show_vertical)
        self.frm_btn_horizon.grid(row=0, column=0, padx=100, pady=30, sticky="wsne")
        self.frm_btn_vertical.grid(row=1, column=0, padx=100, pady=30, sticky="wsne")
        self.frm_btn_back.grid(row=2, column=0,padx=100, pady=30, sticky="wsne")

    # 框架 状态栏
    def create_frm_status(self):
        self.frm_status_label = pytk.PyLabel(self.frm_status,
                                             text="Mysql status：无",
                                             font=g_font)
        self.frm_status_label.grid(row=0, column=0, padx=5, pady=5, sticky="wesn")

    # 返回主菜单
    def Back_main_menu(self):
        self.destroy()
        MainWindow(self)

    # Mysql连接
    def mysql_connect(self):
        try:
            conn.select_db('spectrumdb')
            self.frm_status_label["text"] = u"MySQL status： 已连接到spectrumdb！"
        except MySQLdb.Error, e:
            tkMessageBox.showinfo("状态：", u"MySQL Error： %d:%s" % (e.args[0], e.args[1]))
            self.frm_status_label["text"] = u"MySQL Error： 数据库连接错误！"

    # 横向可视化
    def Show_horizon(self):
        self.withdraw()
        Show_horizon(self)

    # 纵向可视化
    def Show_vertical(self):
        self.withdraw()
        Show_vertical(self)

# 纵向数据显示
class Show_vertical(tk.Toplevel):
    # 初始化函数
    def __init__(self, master=None):
        tk.Toplevel.__init__(self)
        self.original_frame = master
        self.resizable(False, False)
        self.title("数据分析管理")
        self.create_frame()
        self.mysql_connect()

    # 总体框架【上下】
    def create_frame(self):
        self.frm = pytk.PyLabelFrame(self)
        self.frm_status = pytk.PyLabelFrame(self)

        self.frm.grid(row=0, column=0, sticky="wesn")
        self.frm_status.grid(row=1, column=0, sticky="wesn")

        self.create_frm()
        self.create_frm_status()

    # 总体框架【左右】
    def create_frm(self):
        self.frm_left = pytk.PyLabelFrame(self.frm)
        self.frm_right = pytk.PyLabelFrame(self.frm)

        self.frm_left.grid(row=0, column=0, padx=5, pady=5, sticky="wesn")
        self.frm_right.grid(row=0, column=1, padx=5, pady=5, sticky="wesn")

        self.create_frm_left()
        self.create_frm_right()

    # 左
    def create_frm_left(self):
        self.frm_left_label1 = pytk.PyLabel(self.frm_left,
                                                    text="数据索引：",
                                                     font=("Times", 15))
        self.frm_left_data1 = pytk.PyListbox(self.frm_left, height=15, width=55, font=("Monaco", 15))
        self.frm_left_label2 = pytk.PyLabel(self.frm_left,
                                                    text="已选数据：",
                                                     font=("Times", 15))
        self.frm_left_data2 = pytk.PyListbox(self.frm_left, height=15, width=55, font=("Monaco", 15))
        self.frm_left_frm = pytk.PyLabelFrame(self.frm_left)
        self.frm_left_label1.grid(row=0, column=0, padx=0, pady=0, sticky="w")
        self.frm_left_data1.grid(row=1, column=0, padx=0, pady=0, sticky="wesn")
        self.frm_left_frm.grid(row=3, column=0, padx=0, pady=0, sticky="wesn")
        self.frm_left_label2.grid(row=4, column=0, padx=0, pady=0, sticky="w")
        self.frm_left_data2.grid(row=5, column=0, padx=0, pady=0, sticky="wesn")

        self.frm_left_select = pytk.PyButton(self.frm_left_frm,
                                                  text="      ︾      ",
                                                  font=g_font,
                                                  command=self.Select_data)
        self.frm_left_unselect = pytk.PyButton(self.frm_left_frm,
                                                text="      ︽      ",
                                                font=g_font,
                                                command=self.Unselect_data)
        self.frm_left_select.grid(row=0, column=0, padx=100, pady=5, sticky="wesn")
        self.frm_left_unselect.grid(row=0, column=1, padx=100, pady=5, sticky="wesn")

    # 右
    def create_frm_right(self):
        self.frm_right_btn = pytk.PyLabelFrame(self.frm_right)
        self.frm_right_listbox = pytk.PyLabelFrame(self.frm_right)
        self.frm_right_btn.grid(row=1, column=0, padx=20, pady=10, sticky="wesn")
        self.frm_right_listbox.grid(row=0, column=0, padx=20, pady=10, sticky="wesn")

        self.create_frm_right_listbox()
        self.create_frm_right_btn()

    # 列表1
    def create_frm_right_listbox(self):
        names = ("工作泵压力", "动臂大腔压力", "动臂小腔压力", "左转向压力", "右转向压力", "转斗大腔压力", "转斗小腔压力",
                 "转向泵压力", "前进挡压力", "后退挡压力", "1挡压力", "2挡压力", "3挡压力", "4挡压力",
                 "变速箱主压力", "前扭矩", "后扭矩", "变矩器出口压力", "变矩器进口压力", "加速度1", "加速度2",
                 "加速度3", "涡轮转速", "输出轴转速")
        list = tk.StringVar(value=names)
        self.frm_right_listbox_label = pytk.PyLabel(self.frm_right_listbox,
                                                    text="载荷谱数据类型：",
                                                    font=("Times", 15))
        self.frm_right_listbox_data = pytk.PyListbox(self.frm_right_listbox,
                                                     listvariable=list,
                                                     height=28, width=20, font=("Monaco", 15))
        self.frm_right_listbox_data.pack()
        self.frm_right_listbox_label.grid(row=0, column=0, padx=0, pady=0, sticky="w")
        self.frm_right_listbox_data.grid(row=1, column=0, padx=0, pady=0, sticky="wesn")

    # 按钮
    def create_frm_right_btn(self):
        self.frm_right_btn_select = pytk.PyButton(self.frm_right_btn,
                                            text="选择载荷谱数据",
                                            font=g_font,
                                            command=self.Select_spectrum)
        self.frm_right_btn_back = pytk.PyButton(self.frm_right_btn,
                                            text="返回上一级",
                                            font=g_font,
                                            command=self.Back_main_menu)
        self.frm_right_btn_select.grid(row=1, column=0, padx=50, pady=5, sticky="wesn")
        self.frm_right_btn_back.grid(row=2, column=0, padx=50, pady=5, sticky="wesn")

    # 框架 状态栏
    def create_frm_status(self):
        self.frm_status_label = pytk.PyLabel(self.frm_status,
                                             text="Mysql status：无",
                                             font=g_font)
        self.frm_status_label.grid(row=0, column=0, padx=5, pady=5, sticky="wesn")

    # 返回主菜单
    def Back_main_menu(self):
        self.destroy()
        Spectrum_Show(self)

    # mysql初始化
    def mysql_connect(self):
        try:
            # 查询语句
            sql_inquery = "SELECT Driver, Modex, Object, Power, Groupx FROM spectrumtype"
            # 游标，执行，返回stus
            cur = conn.cursor()
            cur.execute(sql_inquery)
            stus = cur.fetchall()
            # 提交
            conn.commit()
            # 关闭游标
            cur.close()
            # 显示
            self.frm_status_label["text"] = u"Mysql status：已连接到数据库spectrumdb！"
            nameall = []
            if stus:
                for i in range(len(stus)):
                    name = "司机：" + str(stus[i]["Driver"]) + "作业模式：" + str(stus[i]["Modex"]) + "作业对象：" + str(
                        stus[i]["Object"]) + "作业功率：" + str(stus[i]["Power"]) + "实验组别：" + str(stus[i]["Groupx"])
                    nameall.append(name)
                    self.frm_left_data1.insert("end", nameall[i])
        except MySQLdb.Error, e:
            tkMessageBox.showinfo("状态：", u"MySQL Error： %d:%s" % (e.args[0], e.args[1]))
            self.frm_status_label["text"] = u"MySQL Error： %d:%s" % (e.args[0], e.args[1])
            self.frm_status_label["text"] = u"Mysql status：数据库连接失败！"

    # 选中载荷谱数据
    def Select_spectrum(self):
        global data_driver, data_mode, data_object, data_power, data_group, data_spectrumtype
        string_data = self.frm_left_data2.get(0, "end")
        data_driver = []
        data_mode = []
        data_object = []
        data_power = []
        data_group = []
        if string_data:
            for i in range(len(string_data)):
                stringxx = string_data[i]
                stringxx = str(stringxx)
                stringxx = string.replace(stringxx, '司机：', '')
                stringxx = string.replace(stringxx, '作业模式：', ',')
                stringxx = string.replace(stringxx, '作业对象：', ',')
                stringxx = string.replace(stringxx, '作业功率：', ',')
                stringxx = string.replace(stringxx, '实验组别：', ',')
                stringxx = string.split(stringxx, ',')

                driverx = stringxx[0]
                modex = stringxx[1]
                objectx = stringxx[2]
                powerx = stringxx[3]
                groupx = stringxx[4]
                # 获取数据
                data_driver.append(driverx)
                data_mode.append(modex)
                data_object.append(objectx)
                data_power.append(powerx)
                data_group.append(groupx)

            # 获取行名
            list_spectrumtype = ("PressureGZB", "PressureDBDQ", "PressureDBXQ", "PressureZZX", "PressureYZX", "PressureZDDQ", "PressureZDXQ",
                     "PressureZXB", "PressureQJD", "PressureHTD", "PressureF1", "PressureF2", "PressureF3", "PressureF4",
                     "PressureBSX", "PressureQNJ", "PressureHNJ", "PressureBJQCK", "PressureBJQJK", "Acce1", "Acce2",
                     "Acce3", "SpeedWL", "SpeedSCZ")
            indexs = self.frm_right_listbox_data.curselection()
            if indexs:
                indexs_data = indexs[0]
                data_spectrumtype = list_spectrumtype[indexs_data]

                # 跳转界面
                self.destroy()
                Plot_vertical(self)
            else:
                tkMessageBox.showinfo("提示", u"请选择载荷谱数据类型")
        else:
            tkMessageBox.showinfo("提示", u"请选择数据索引")

    # 选中索引
    def Select_data(self):
        indexs = self.frm_left_data1.curselection()
        string1 = self.frm_left_data1.get(indexs)
        indexs_data = indexs[0]
        self.frm_left_data1.delete(indexs_data)
        self.frm_left_data2.insert("end", string1)

    # 取消选中索引
    def Unselect_data(self):
        indexs = self.frm_left_data2.curselection()
        string1 = self.frm_left_data2.get(indexs)
        indexs_data = indexs[0]
        self.frm_left_data2.delete(indexs_data)
        self.frm_left_data1.insert("end", string1)

# 纵向数据画图
class Plot_vertical(tk.Toplevel):
    # 初始化函数
    def __init__(self, master=None):
        tk.Toplevel.__init__(self)
        self.original_frame = master
        self.resizable(False, False)
        self.title("数据分析管理")
        self.create_frame()
        self.Plot_x()

    # 框架
    def create_frame(self):
        self.frm = pytk.PyLabelFrame(self)
        self.frm_status = pytk.PyLabelFrame(self)

        self.frm.grid(row=0, column=0, sticky="wesn")
        self.frm_status.grid(row=1, column=0, sticky="wesn")
        self.create_frm()
        self.create_frm_status()

    # 总体框架【左右】
    def create_frm(self):
        '''
        上半部分窗口分为左右2个部分
        '''
        self.frm_left = pytk.PyLabelFrame(self.frm)
        self.frm_right = pytk.PyLabelFrame(self.frm)

        self.frm_left.grid(row=0, column=0, padx=5, pady=5, sticky="wesn")
        self.frm_right.grid(row=0, column=1, padx=5, pady=5, sticky="wesn")

        self.create_frm_left()
        self.create_frm_right()

    # 框架【图】
    def create_frm_left(self):
        # 在Tk的GUI上放置一个画布，并用.grid()来调整布局
        self.draw = Figure(figsize=(8, 8), dpi=100)
        self.draw.canvas = FigureCanvasTkAgg(self.draw, self.frm_left)
        self.draw.canvas.show()
        self.frm_left_label = pytk.PyLabel(self.frm_left,
                                           text="载荷谱显示：",
                                           font=("Times", 15))
        self.frm_left_label.grid(row=0, column=0, padx=0, pady=0, sticky="w")
        self.draw.canvas.get_tk_widget().grid(row=1, columnspan=3)

    # 框架【表】
    def create_frm_right(self):
        self.frm_listbox_label_frm = pytk.PyLabelFrame(self.frm_right)
        self.frm_listbox = pytk.PyListbox(self.frm_right, height=12, width=27, font=("Monaco", 15))
        self.frm_btn_quit = pytk.PyLabelFrame(self.frm_right)
        self.frm_rbtn = pytk.PyLabelFrame(self.frm_right)

        self.frm_rbtn_label_frm = pytk.PyLabelFrame(self.frm_right)

        radio_intvar = tk.IntVar()
        self.frm_rbtn_mean = pytk.PyRadiobutton(self.frm_rbtn, text="均值(Mean)", variable=radio_intvar,
                                                           value=0, font=("Monaco", 15), command=self.rbtn_mean)
        self.frm_rbtn_max = pytk.PyRadiobutton(self.frm_rbtn, text="最大值(Max)", variable=radio_intvar,
                                                           value=1, font=("Monaco", 15), command=self.rbtn_max)
        self.frm_rbtn_min = pytk.PyRadiobutton(self.frm_rbtn, text="最小值(Min)", variable=radio_intvar,
                                                           value=2, font=("Monaco", 15), command=self.rbtn_min)
        self.frm_rbtn_std = pytk.PyRadiobutton(self.frm_rbtn, text="标准差(Std)", variable=radio_intvar,
                                                           value=3, font=("Monaco", 15), command=self.rbtn_std)
        self.frm_rbtn_var = pytk.PyRadiobutton(self.frm_rbtn, text="方差(Var)", variable=radio_intvar,
                                                           value=4, font=("Monaco", 15), command=self.rbtn_var)

        self.frm_listbox_label = pytk.PyLabel(self.frm_listbox_label_frm,
                                           text="数据信息：",
                                           font=("Times", 15))
        self.frm_rbtn_label = pytk.PyLabel(self.frm_rbtn_label_frm,
                                           text="操作选择：",
                                           font=("Times", 15))
        self.frm_listbox_label.grid(row=0, column=0, padx=0, pady=0, sticky="w")
        self.frm_rbtn_label.grid(row=0, column=0, padx=0, pady=0, sticky="w")

        self.frm_btn_hist_btn = pytk.PyButton(self.frm_btn_quit,
                                               text="直方统计",
                                               font=g_font,
                                               command=self.Plot_Hist)
        self.frm_btn_hist_btn.grid(row=0, column=0, padx=120, pady=10, sticky="wesn")

        self.frm_btn_time_btn = pytk.PyButton(self.frm_btn_quit,
                                               text="时域波形",
                                               font=g_font,
                                               command=self.Plot_Time)
        self.frm_btn_time_btn.grid(row=1, column=0, padx=120, pady=10, sticky="wesn")

        self.frm_btn_quit_btn = pytk.PyButton(self.frm_btn_quit,
                                               text="返回上一级",
                                               font=g_font,
                                               command=self.Back_main_menu)
        self.frm_btn_quit_btn.grid(row=2, column=0, padx=120, pady=10, sticky="wesn")

        self.frm_listbox_label_frm.grid(row=0, column=0, padx=20, pady=0, sticky="wesn")
        self.frm_listbox.grid(row=1, column=0, padx=20, pady=10, sticky="wesn")
        self.frm_rbtn.grid(row=3, column=0, padx=20, pady=10, sticky="wesn")
        self.frm_btn_quit.grid(row=4, column=0, padx=20, pady=10, sticky="wesn")

        self.frm_rbtn_label_frm.grid(row=2, column=0, padx=20, pady=0, sticky="wsen")
        self.frm_rbtn_mean.grid(row=1, column=0,padx=0, pady=10, sticky="w")
        self.frm_rbtn_max.grid(row=2, column=0, padx=0, pady=10, sticky="w")
        self.frm_rbtn_min.grid(row=3, column=0, padx=0, pady=10, sticky="w")
        self.frm_rbtn_std.grid(row=4, column=0, padx=0, pady=10, sticky="w")
        self.frm_rbtn_var.grid(row=5, column=0, padx=0, pady=10, sticky="w")

    # 框架 状态栏
    def create_frm_status(self):
        self.frm_status_label = pytk.PyLabel(self.frm_status,
                                             text="Mysql status：无",
                                             font=g_font)
        self.frm_status_label.grid(row=0, column=0, padx=5, pady=5, sticky="wesn")

    # 返回上一级
    def Back_main_menu(self):
        self.destroy()
        Show_vertical(self)

    # 画图
    def Plot_x(self):
        name_dict={"PressureGZB":"工作泵压力", "PressureDBDQ":"动臂大腔压力", "PressureDBXQ":"动臂小腔压力",
                   "PressureZZX":"左转向压力", "PressureYZX":"右转向压力", "PressureZDDQ":"转斗大腔压力",
                   "PressureZDXQ":"转斗小腔压力", "PressureZXB":"转向泵压力", "PressureQJD":"前进挡压力",
                   "PressureHTD":"后退挡压力", "PressureF1":"1挡压力", "PressureF2":"2挡压力", "PressureF3":"3挡压力",
                   "PressureF4":"4挡压力", "PressureBSX":"变速箱压力", "PressureQNJ":"前扭矩", "PressureHNJ":"后扭矩",
                   "PressureBJQCK":"变矩器出口压力", "PressureBJQJK":"变矩器进口压力", "Acce1":"加速度1", "Acce2":"加速度2",
                     "Acce3":"加速度3", "SpeedWL":"涡轮转速", "SpeedSCZ":"输出轴转速"}
        try:
            # 查询语句
            self.draw.clf()
            color = ['b', 'r', 'y', 'g', 'm', 'k', 'c', 'b', 'r', 'y', 'g', 'm', 'k', 'c']
            self._data_dict = {}
            self._time_dict = {}
            # 画图
            for i in range(len(data_driver)):
                driver = str(data_driver[i])
                mode = str(data_mode[i])
                object = str(data_object[i])
                power = str(data_power[i])
                group = str(data_group[i])
                sql_id = "SELECT SpectrumtypeID FROM spectrumtype WHERE Driver = '{0}' AND Object = '{1}' AND Modex = '{2}' AND Power = '{3}' AND Groupx= '{4}'".format(
                    driver, object, mode, power, group)
                # 游标，执行，返回stus
                cur = conn.cursor()
                cur.execute(sql_id)
                stus = cur.fetchall()
                # 提交
                conn.commit()
                # 关闭游标
                cur.close()
                if stus:
                    id = stus[0]["SpectrumtypeID"]
                    # 数据
                    sql_data = "SELECT {0} FROM spectrumdata WHERE SpectrumtypeID = '{1}'".format(data_spectrumtype, id)
                    # 游标，执行，返回stus
                    cur = conn.cursor()
                    cur.execute(sql_data)
                    stus = cur.fetchall()
                    # 提交
                    conn.commit()
                    # 关闭游标
                    cur.close()
                    data = []
                    if stus:
                        for j in range(len(stus)):
                            data.append(stus[j][data_spectrumtype])
                    self._data_dict[i] = data
                    # 时间
                    sql_time = "SELECT Timex FROM spectrumdata WHERE SpectrumtypeID  = '{0}'".format(id)
                    # 游标，执行，返回stus
                    cur = conn.cursor()
                    cur.execute(sql_time)
                    stus = cur.fetchall()
                    # 提交
                    conn.commit()
                    # 关闭游标
                    cur.close()
                    time = []
                    if stus:
                        for j in range(len(stus)):
                            time.append(stus[j]["Timex"])
                    self._time_dict[i] = time

                    # 画图
                    x = self._time_dict[i]
                    y = self._data_dict[i]
                    num = 100 * (len(data_driver)) + 10 + i + 1
                    self.draw_a = self.draw.add_subplot(num)
                    strxx = driver+"_"+object+"_"+mode+"_"+power+"_"+group
                    self.draw_a.plot(x, y, color[i], linewidth=1)
                    self.draw_a.legend((strxx,), loc='upper left')  # 加一个逗号》》元组类型
                    self.draw_a.set_ylabel("数值")
                    if i == 0:
                        self.draw_a.set_title(name_dict[data_spectrumtype])
                    if i == len(data_driver)-1:
                        self.draw_a.set_xlabel("时间(s)")
            # 统计
            self._mean = []
            self._max = []
            self._min = []
            self._std = []
            self._var = []
            for i in range(len(data_driver)):
                narray = np.array(self._data_dict[i])
                datamean = np.mean(narray)
                datastd = np.std(narray)
                datavar = np.var(narray)
                datamin = np.min(narray)
                datamax = np.max(narray)
                self._mean.append(datamean)
                self._max.append(datamax)
                self._min.append(datamin)
                self._std.append(datastd)
                self._var.append(datavar)
            self.frm_status_label["text"] = u"Mysql status：查询成功！"
        except MySQLdb.Error:
            self.frm_status_label["text"] = u"Mysql status：查询失败！"

    # 直方图
    def Plot_Hist(self):
        # 画图
        self.draw.clf()
        color = ['b', 'r', 'y', 'g', 'm', 'k', 'c', 'b', 'r', 'y', 'g', 'm', 'k', 'c']
        name_dict = {"PressureGZB": "工作泵压力", "PressureDBDQ": "动臂大腔压力", "PressureDBXQ": "动臂小腔压力",
                     "PressureZZX": "左转向压力", "PressureYZX": "右转向压力", "PressureZDDQ": "转斗大腔压力",
                     "PressureZDXQ": "转斗小腔压力", "PressureZXB": "转向泵压力", "PressureQJD": "前进挡压力",
                     "PressureHTD": "后退挡压力", "PressureF1": "1挡压力", "PressureF2": "2挡压力", "PressureF3": "3挡压力",
                     "PressureF4": "4挡压力", "PressureBSX": "变速箱压力", "PressureQNJ": "前扭矩", "PressureHNJ": "后扭矩",
                     "PressureBJQCK": "变矩器出口压力", "PressureBJQJK": "变矩器进口压力", "Acce1": "加速度1", "Acce2": "加速度2",
                     "Acce3": "加速度3", "SpeedWL": "涡轮转速", "SpeedSCZ": "输出轴转速"}
        for i in range(len(data_driver)):
            driver = str(data_driver[i])
            mode = str(data_mode[i])
            object = str(data_object[i])
            power = str(data_power[i])
            group = str(data_group[i])
            # 画图
            narray = np.array(self._data_dict[i],dtype=np.float64)
            num = 100 * (len(data_driver)) + 10 + i + 1
            self.draw_a = self.draw.add_subplot(num)
            strxx = driver + "_" + object + "_" + mode + "_" + power + "_" + group
            self.draw_a.hist(narray, color=color[i])
            self.draw_a.legend((strxx,), loc='upper left')  # 加一个逗号》》元组类型
            self.draw_a.set_ylabel("频次")
            if i == 0:
                self.draw_a.set_title(name_dict[data_spectrumtype])
            if i == len(data_driver) - 1:
                self.draw_a.set_xlabel("数值")
            self.draw.canvas.show()
        self.frm_status_label["text"] = u"Status：显示直方图！"

    # 时域图
    def Plot_Time(self):
        # 画图
        self.draw.clf()
        color = ['b', 'r', 'y', 'g', 'm', 'k', 'c', 'b', 'r', 'y', 'g', 'm', 'k', 'c']
        name_dict = {"PressureGZB": "工作泵压力", "PressureDBDQ": "动臂大腔压力", "PressureDBXQ": "动臂小腔压力",
                     "PressureZZX": "左转向压力", "PressureYZX": "右转向压力", "PressureZDDQ": "转斗大腔压力",
                     "PressureZDXQ": "转斗小腔压力", "PressureZXB": "转向泵压力", "PressureQJD": "前进挡压力",
                     "PressureHTD": "后退挡压力", "PressureF1": "1挡压力", "PressureF2": "2挡压力", "PressureF3": "3挡压力",
                     "PressureF4": "4挡压力", "PressureBSX": "变速箱压力", "PressureQNJ": "前扭矩", "PressureHNJ": "后扭矩",
                     "PressureBJQCK": "变矩器出口压力", "PressureBJQJK": "变矩器进口压力", "Acce1": "加速度1", "Acce2": "加速度2",
                     "Acce3": "加速度3", "SpeedWL": "涡轮转速", "SpeedSCZ": "输出轴转速"}
        for i in range(len(data_driver)):
            driver = str(data_driver[i])
            mode = str(data_mode[i])
            object = str(data_object[i])
            power = str(data_power[i])
            group = str(data_group[i])
            # 画图
            x = self._time_dict[i]
            y = self._data_dict[i]
            num = 100 * (len(data_driver)) + 10 + i + 1
            self.draw_a = self.draw.add_subplot(num)
            strxx = driver + "_" + object + "_" + mode + "_" + power + "_" + group
            self.draw_a.plot(x, y, color[i], linewidth=1)
            self.draw_a.legend((strxx,), loc='upper left')  # 加一个逗号》》元组类型
            self.draw_a.set_ylabel("数值")
            if i == 0:
                self.draw_a.set_title(name_dict[data_spectrumtype])
            if i == len(data_driver) - 1:
                self.draw_a.set_xlabel("时间(s)")
            self.draw.canvas.show()
        self.frm_status_label["text"] = u"Status：显示时域图！"

    # 均值
    def rbtn_mean(self):
        self.frm_listbox.delete("0", "end")
        for i in range(len(data_driver)):
            driver = str(data_driver[i])
            mode = str(data_mode[i])
            object = str(data_object[i])
            power = str(data_power[i])
            group = str(data_group[i])
            name = '【均值】' + driver + '_' + mode + '_' + object + '_' + power + '_' + group
            self.frm_listbox.insert("end", name)
            self.frm_listbox.insert("end", str(round(self._mean[i])))

    # 最大值
    def rbtn_max(self):
        self.frm_listbox.delete("0", "end")
        for i in range(len(data_driver)):
            driver = str(data_driver[i])
            mode = str(data_mode[i])
            object = str(data_object[i])
            power = str(data_power[i])
            group = str(data_group[i])
            name = '【最大值】' + driver + '_' + mode + '_' + object + '_' + power + '_' + group
            self.frm_listbox.insert("end", name)
            self.frm_listbox.insert("end", str(round(self._max[i])))

    # 最小值
    def rbtn_min(self):
        self.frm_listbox.delete("0", "end")
        for i in range(len(data_driver)):
            driver = str(data_driver[i])
            mode = str(data_mode[i])
            object = str(data_object[i])
            power = str(data_power[i])
            group = str(data_group[i])
            name = '【最小值】' + driver + '_' + mode + '_' + object + '_' + power + '_' + group
            self.frm_listbox.insert("end", name)
            self.frm_listbox.insert("end", str(round(self._min[i])))

    # 标准差
    def rbtn_std(self):
        self.frm_listbox.delete("0", "end")
        for i in range(len(data_driver)):
            driver = str(data_driver[i])
            mode = str(data_mode[i])
            object = str(data_object[i])
            power = str(data_power[i])
            group = str(data_group[i])
            name = '【标准差】' + driver + '_' + mode + '_' + object + '_' + power + '_' + group
            self.frm_listbox.insert("end", name)
            self.frm_listbox.insert("end", str(round(self._std[i])))

    # 方差
    def rbtn_var(self):
        self.frm_listbox.delete("0", "end")
        for i in range(len(data_driver)):
            driver = str(data_driver[i])
            mode = str(data_mode[i])
            object = str(data_object[i])
            power = str(data_power[i])
            group = str(data_group[i])
            name = '【方差】' + driver + '_' + mode + '_' + object + '_' + power + '_' + group
            self.frm_listbox.insert("end", name)
            self.frm_listbox.insert("end", str(round(self._var[i])))

# 横向数据显示
class Show_horizon(tk.Toplevel):
    # 初始化函数
    def __init__(self, master=None):
        tk.Toplevel.__init__(self)
        self.original_frame = master
        self.resizable(False, False)
        self.title("数据分析管理")
        self.create_frame()
        self.mysql_connect()

    # 总体框架【上下】
    def create_frame(self):
        self.frm = pytk.PyLabelFrame(self)
        self.frm_status = pytk.PyLabelFrame(self)

        self.frm.grid(row=0, column=0, sticky="wesn")
        self.frm_status.grid(row=1, column=0, sticky="wesn")

        self.create_frm()
        self.create_frm_status()

    # 总体框架【左右】
    def create_frm(self):
        '''
        上半部分窗口分为左右2个部分
        '''
        self.frm_left = pytk.PyLabelFrame(self.frm)
        self.frm_right = pytk.PyLabelFrame(self.frm)

        self.frm_left.grid(row=0, column=1, padx=5, pady=5, sticky="wesn")
        self.frm_right.grid(row=0, column=0, padx=5, pady=5, sticky="wesn")

        self.create_frm_left()
        self.create_frm_right()

    # 框架【左】
    def create_frm_left(self):
        self.frm_left_label = pytk.PyLabel(self.frm_left,
                                                    text="数据索引：",
                                                     font=("Times", 15))
        self.frm_left_data = pytk.PyListbox(self.frm_left, height=21, width=55, font=("Monaco", 15))
        self.frm_left_data.pack()
        self.frm_left_frm = pytk.PyListbox(self.frm_left)
        self.frm_left_btn_check = pytk.PyButton(self.frm_left_frm,
                                            text="确定",
                                            font=g_font,
                                            command=self.btn_check)
        self.frm_left_btn_quit = pytk.PyButton(self.frm_left_frm,
                                            text="返回上一级",
                                            font=g_font,
                                            command=self.Back_main_menu)
        self.frm_left_label.grid(row=0, column=0, padx=0, pady=0, sticky="w")
        self.frm_left_data.grid(row=1, column=0, padx=0, pady=0, sticky="wesn")
        self.frm_left_frm.grid(row=2, column=0, padx=0, pady=0, sticky="wesn")

        self.frm_left_btn_check.grid(row=0, column=0, padx=300, pady=10, sticky="wsne")
        self.frm_left_btn_quit.grid(row=1, column=0, padx=300, pady=10, sticky="wesn")

    # 框架【右】
    def create_frm_right(self):
        self.frm_right_listbox1 = pytk.PyLabelFrame(self.frm_right)
        self.frm_right_btn = pytk.PyLabelFrame(self.frm_right)
        self.frm_right_listbox2 = pytk.PyLabelFrame(self.frm_right)
        self.frm_right_listbox1.grid(row=0, column=0, padx=5, pady=10, sticky="wesn")
        self.frm_right_btn.grid(row=0, column=1, padx=5, pady=10, sticky="wesn")
        self.frm_right_listbox2.grid(row=0, column=2, padx=5, pady=10, sticky="wesn")

        self.create_frm_right_listbox1()
        self.create_frm_right_btn()
        self.create_frm_right_listbox2()

    # 列表1
    def create_frm_right_listbox1(self):
        names = ("工作泵压力", "动臂大腔压力", "动臂小腔压力", "左转向压力", "右转向压力", "转斗大腔压力", "转斗小腔压力",
                 "转向泵压力", "前进挡压力", "后退挡压力", "1挡压力", "2挡压力", "3挡压力", "4挡压力",
                 "变速箱主压力", "前扭矩", "后扭矩", "变矩器出口压力", "变矩器进口压力", "加速度1", "加速度2",
                 "加速度3", "涡轮转速", "输出轴转速")
        list = tk.StringVar(value=names)
        self.frm_right_listbox1_label = pytk.PyLabel(self.frm_right_listbox1,
                                                    text="载荷谱数据类型：",
                                                    font=("Times", 15))
        self.frm_right_listbox1_data = pytk.PyListbox(self.frm_right_listbox1, listvariable=list,
                                                      height=25, width=15, font=("Monaco", 15))
        self.frm_right_listbox1_data.pack()
        self.frm_right_listbox1_label.grid(row=0, column=0, padx=0, pady=0, sticky="w")
        self.frm_right_listbox1_data.grid(row=1, column=0, padx=0, pady=0, sticky="wesn")

    # 按钮
    def create_frm_right_btn(self):
        self.frm_right_btn1 = pytk.PyButton(self.frm_right_btn,
                                                  text="选择>>",
                                                  font=g_font,
                                                  command=self.btn_toright)
        self.frm_right_btn2 = pytk.PyButton(self.frm_right_btn,
                                            text="<<取消",
                                            font=g_font,
                                            command=self.btn_toleft)
        self.frm_right_btn1.grid(row=0, column=0, padx=0, pady=130, sticky="wesn")
        self.frm_right_btn2.grid(row=1, column=0, padx=0, pady=130, sticky="wesn")

    # 列表2
    def create_frm_right_listbox2(self):
        self.frm_right_listbox2_label = pytk.PyLabel(self.frm_right_listbox2,
                                                    text="载荷谱数据（已选）：",
                                                    font=("Times", 15))
        self.frm_right_listbox2_data = pytk.PyListbox(self.frm_right_listbox2, height=25, width=15, font=("Monaco", 15))
        self.frm_right_listbox2_data.pack()
        self.frm_right_listbox2_label.grid(row=0, column=0, padx=0, pady=0, sticky="w")
        self.frm_right_listbox2_data.grid(row=1, column=0, padx=0, pady=0, sticky="wesn")

    # 框架 状态栏
    def create_frm_status(self):
        self.frm_status_label = pytk.PyLabel(self.frm_status,
                                             text="Mysql status：无！",
                                             font=g_font)
        self.frm_status_label.grid(row=0, column=0, padx=5, pady=5, sticky="wesn")

    # mysql初始化
    def mysql_connect(self):
        try:
            # 查询语句
            sql_inquery = "SELECT Driver, Modex, Object, Power, Groupx FROM spectrumtype"
            # 游标，执行，返回stus
            cur = conn.cursor()
            cur.execute(sql_inquery)
            stus = cur.fetchall()
            # 提交
            conn.commit()
            # 关闭游标
            cur.close()
            # 显示
            self.frm_status_label["text"] = u"Mysql status：已连接到数据库spectrumdb！"
            nameall = []
            if stus:
                for i in range(len(stus)):
                    name = "司机：" + str(stus[i]["Driver"]) + "作业模式：" + str(stus[i]["Modex"]) + "作业对象：" + str(
                        stus[i]["Object"]) + "作业功率：" + str(stus[i]["Power"]) + "实验组别：" + str(stus[i]["Groupx"])
                    nameall.append(name)
                    self.frm_left_data.insert("end", nameall[i])
        except MySQLdb.Error, e:
            tkMessageBox.showinfo("状态：", u"MySQL Error： %d:%s" % (e.args[0], e.args[1]))
            self.frm_status_label["text"] = u"MySQL Error： %d:%s" % (e.args[0], e.args[1])
            self.frm_status_label["text"] = u"Mysql status：数据库连接失败！"

    # 返回主菜单
    def Back_main_menu(self):
        self.destroy()
        Spectrum_Show(self)

    # 选择
    def btn_toright(self):
        indexs = self.frm_right_listbox1_data.curselection()
        string1 = self.frm_right_listbox1_data.get(indexs)
        indexs_data = indexs[0]
        self.frm_right_listbox1_data.delete(indexs_data)
        self.frm_right_listbox2_data.insert("end", string1)

    # 取消选择
    def btn_toleft(self):
        indexs = self.frm_right_listbox2_data.curselection()
        string1 = self.frm_right_listbox2_data.get(indexs)
        indexs_data = indexs[0]
        self.frm_right_listbox2_data.delete(indexs_data)
        self.frm_right_listbox1_data.insert("end", string1)

    # 确定选择
    def btn_check(self):
        global datax_driver, datax_mode, datax_object, datax_power, datax_group, datax_spectrumtype
        indexs = self.frm_left_data.curselection()
        if indexs:
            num_indexs = indexs[0]
            string_data = self.frm_left_data.get(num_indexs)
            stringxx = string_data
            stringxx = str(stringxx)
            stringxx = string.replace(stringxx, '司机：', '')
            stringxx = string.replace(stringxx, '作业模式：', ',')
            stringxx = string.replace(stringxx, '作业对象：', ',')
            stringxx = string.replace(stringxx, '作业功率：', ',')
            stringxx = string.replace(stringxx, '实验组别：', ',')
            stringxx = string.split(stringxx, ',')

            datax_driver = stringxx[0]
            datax_mode = stringxx[1]
            datax_object = stringxx[2]
            datax_power = stringxx[3]
            datax_group = stringxx[4]

            datax_spectrumtype = []
            # 获取行名
            name_dict = {"工作泵压力": "PressureGZB", "动臂大腔压力": "PressureDBDQ", "动臂小腔压力": "PressureDBXQ",
                         "左转向压力": "PressureZZX", "右转向压力": "PressureYZX", "转斗大腔压力": "PressureZDDQ",
                         "转斗小腔压力": "PressureZDXQ", "转向泵压力": "PressureZXB", "前进挡压力": "PressureQJD",
                         "后退挡压力": "PressureHTD", "1挡压力": "PressureF1", "2挡压力": "PressureF2", "3挡压力": "PressureF3",
                         "4挡压力": "PressureF4", "变速箱压力": "PressureBSX", "前扭矩": "PressureQNJ", "后扭矩": "PressureQNJ",
                         "变矩器出口压力": "PressureBJQCK", "变矩器进口压力": "PressureBJQJK", "加速度1": "Acce1", "加速度2": "Acce2",
                         "加速度3": "Acce3", "涡轮转速": "SpeedWL", "输出轴转速": "SpeedSCZ"}
            data = self.frm_right_listbox2_data.get(0, "end")
            if data:
                for i in range(len(data)):
                    a=str(data[i])
                    name = name_dict[a]
                    datax_spectrumtype.append(name)
                # 跳转界面
                self.destroy()
                Plot_horizon(self)
            else:
                tkMessageBox.showinfo("提示", u"请选择载荷谱数据类型")
        else:
            tkMessageBox.showinfo("提示", u"请选择数据索引")

# 横向数据画图
class Plot_horizon(tk.Toplevel):
    # 初始化函数
    def __init__(self, master=None):
        tk.Toplevel.__init__(self)
        self.original_frame = master
        self.resizable(False, False)
        self.title("数据分析管理")
        self.create_frame()
        self.Plot_x()

    # 框架
    def create_frame(self):
        self.frm = pytk.PyLabelFrame(self)
        self.frm_status = pytk.PyLabelFrame(self)

        self.frm.grid(row=0, column=0, sticky="wesn")
        self.frm_status.grid(row=1, column=0, sticky="wesn")
        self.create_frm()
        self.create_frm_status()

    # 总体框架【左右】
    def create_frm(self):
        '''
        上半部分窗口分为左右2个部分
        '''
        self.frm_left = pytk.PyLabelFrame(self.frm)
        self.frm_right = pytk.PyLabelFrame(self.frm)

        self.frm_left.grid(row=0, column=0, padx=5, pady=5, sticky="wesn")
        self.frm_right.grid(row=0, column=1, padx=5, pady=5, sticky="wesn")

        self.create_frm_left()
        self.create_frm_right()

    # 框架【图】
    def create_frm_left(self):
        # 在Tk的GUI上放置一个画布，并用.grid()来调整布局
        self.draw = Figure(figsize=(8, 9), dpi=100)
        self.draw.canvas = FigureCanvasTkAgg(self.draw, self.frm_left)
        self.draw.canvas.show()
        self.frm_left_label = pytk.PyLabel(self.frm_left,
                                           text="载荷谱显示：",
                                           font=("Times", 15))
        self.frm_left_label.grid(row=0, column=0, padx=0, pady=0, sticky="w")
        self.draw.canvas.get_tk_widget().grid(row=1, columnspan=3)

    # 框架【表】
    def create_frm_right(self):
        self.frm_listbox_label_frm = pytk.PyLabelFrame(self.frm_right)
        self.frm_listbox = pytk.PyListbox(self.frm_right, height=12, width=27, font=("Monaco", 15))
        self.frm_btn_quit = pytk.PyLabelFrame(self.frm_right)
        self.frm_rbtn = pytk.PyLabelFrame(self.frm_right)

        self.frm_rbtn_label_frm = pytk.PyLabelFrame(self.frm_right)

        radio_intvar = tk.IntVar()
        self.frm_rbtn_mean = pytk.PyRadiobutton(self.frm_rbtn, text="均值(Mean)", variable=radio_intvar,
                                                value=0, font=("Monaco", 15), command=self.rbtn_mean)
        self.frm_rbtn_max = pytk.PyRadiobutton(self.frm_rbtn, text="最大值(Max)", variable=radio_intvar,
                                               value=1, font=("Monaco", 15), command=self.rbtn_max)
        self.frm_rbtn_min = pytk.PyRadiobutton(self.frm_rbtn, text="最小值(Min)", variable=radio_intvar,
                                               value=2, font=("Monaco", 15), command=self.rbtn_min)
        self.frm_rbtn_std = pytk.PyRadiobutton(self.frm_rbtn, text="标准差(Std)", variable=radio_intvar,
                                               value=3, font=("Monaco", 15), command=self.rbtn_std)
        self.frm_rbtn_var = pytk.PyRadiobutton(self.frm_rbtn, text="方差(Var)", variable=radio_intvar,
                                               value=4, font=("Monaco", 15), command=self.rbtn_var)

        self.frm_listbox_label = pytk.PyLabel(self.frm_listbox_label_frm,
                                              text="数据信息：",
                                              font=("Times", 15))
        self.frm_rbtn_label = pytk.PyLabel(self.frm_rbtn_label_frm,
                                           text="操作选择：",
                                           font=("Times", 15))
        self.frm_listbox_label.grid(row=0, column=0, padx=0, pady=0, sticky="w")
        self.frm_rbtn_label.grid(row=0, column=0, padx=0, pady=0, sticky="w")

        self.frm_btn_hist_btn = pytk.PyButton(self.frm_btn_quit,
                                              text="直方统计",
                                              font=g_font,
                                              command=self.Plot_Hist)
        self.frm_btn_hist_btn.grid(row=0, column=0, padx=120, pady=10, sticky="wesn")

        self.frm_btn_time_btn = pytk.PyButton(self.frm_btn_quit,
                                              text="时域(子图)",
                                              font=g_font,
                                              command=self.Plot_Time)
        self.frm_btn_time_btn.grid(row=1, column=0, padx=120, pady=10, sticky="wesn")

        self.frm_btn_time1_btn = pytk.PyButton(self.frm_btn_quit,
                                              text="时域(整体)",
                                              font=g_font,
                                              command=self.Plot_Time1)
        self.frm_btn_time1_btn.grid(row=2, column=0, padx=120, pady=10, sticky="wesn")

        self.frm_btn_quit_btn = pytk.PyButton(self.frm_btn_quit,
                                              text="返回上一级",
                                              font=g_font,
                                              command=self.Back_main_menu)
        self.frm_btn_quit_btn.grid(row=3, column=0, padx=120, pady=10, sticky="wesn")

        self.frm_listbox_label_frm.grid(row=0, column=0, padx=20, pady=0, sticky="wesn")
        self.frm_listbox.grid(row=1, column=0, padx=20, pady=10, sticky="wesn")
        self.frm_rbtn.grid(row=3, column=0, padx=20, pady=10, sticky="wesn")
        self.frm_btn_quit.grid(row=4, column=0, padx=20, pady=10, sticky="wesn")

        self.frm_rbtn_label_frm.grid(row=2, column=0, padx=20, pady=0, sticky="wsen")
        self.frm_rbtn_mean.grid(row=1, column=0, pady=10, sticky="w")
        self.frm_rbtn_max.grid(row=2, column=0, padx=0, pady=10, sticky="w")
        self.frm_rbtn_min.grid(row=3, column=0, padx=0, pady=10, sticky="w")
        self.frm_rbtn_std.grid(row=4, column=0, padx=0, pady=10, sticky="w")
        self.frm_rbtn_var.grid(row=5, column=0, padx=0, pady=10, sticky="w")

    # 框架 状态栏
    def create_frm_status(self):
        self.frm_status_label = pytk.PyLabel(self.frm_status,
                                             text="Mysql status：无",
                                             font=g_font)
        self.frm_status_label.grid(row=0, column=0, padx=5, pady=5, sticky="wesn")

    # 返回上一级
    def Back_main_menu(self):
        self.destroy()
        Show_horizon(self)

    # 画图
    def Plot_x(self):
        name_dict = {"PressureGZB": "工作泵压力", "PressureDBDQ": "动臂大腔压力", "PressureDBXQ": "动臂小腔压力",
                     "PressureZZX": "左转向压力", "PressureYZX": "右转向压力", "PressureZDDQ": "转斗大腔压力",
                     "PressureZDXQ": "转斗小腔压力", "PressureZXB": "转向泵压力", "PressureQJD": "前进挡压力",
                     "PressureHTD": "后退挡压力", "PressureF1": "1挡压力", "PressureF2": "2挡压力", "PressureF3": "3挡压力",
                     "PressureF4": "4挡压力", "PressureBSX": "变速箱压力", "PressureQNJ": "前扭矩", "PressureHNJ": "后扭矩",
                     "PressureBJQCK": "变矩器出口压力", "PressureBJQJK": "变矩器进口压力", "Acce1": "加速度1", "Acce2": "加速度2",
                     "Acce3": "加速度3", "SpeedWL": "涡轮转速", "SpeedSCZ": "输出轴转速"}
        try:
            # 查询语句
            self.draw.clf()
            color = ['b', 'r', 'y', 'g', 'm', 'k', 'c', 'b', 'r', 'y', 'g', 'm', 'k', 'c']
            self._data_dict = {}
            self._time_dict = {}
            # 画图
            for i in range(len(datax_spectrumtype)):
                sql_id = "SELECT SpectrumtypeID FROM spectrumtype WHERE Driver = '{0}' AND Object = '{1}' AND Modex = '{2}' AND Power = '{3}' AND Groupx= '{4}'".format(
                    datax_driver, datax_object, datax_mode, datax_power, datax_group)
                # 游标，执行，返回stus
                cur = conn.cursor()
                cur.execute(sql_id)
                stus = cur.fetchall()
                # 提交
                conn.commit()
                # 关闭游标
                cur.close()
                if stus:
                    id = stus[0]["SpectrumtypeID"]

                    # 数据
                    sql_data = "SELECT {0} FROM spectrumdata WHERE SpectrumtypeID = '{1}'".format(
                        datax_spectrumtype[i], id)
                    # 游标，执行，返回stus
                    cur = conn.cursor()
                    cur.execute(sql_data)
                    stus = cur.fetchall()
                    # 提交
                    conn.commit()
                    # 关闭游标
                    cur.close()
                    data = []
                    if stus:
                        for j in range(len(stus)):
                            data.append(stus[j][datax_spectrumtype[i]])
                    self._data_dict[i] = data

                    # 时间
                    sql_time = "SELECT Timex FROM spectrumdata WHERE SpectrumtypeID  = '{0}'".format(id)
                    # 游标，执行，返回stus
                    cur = conn.cursor()
                    cur.execute(sql_time)
                    stus = cur.fetchall()
                    # 提交
                    conn.commit()
                    # 关闭游标
                    cur.close()
                    time = []
                    if stus:
                        for j in range(len(stus)):
                            time.append(stus[j]["Timex"])
                    self._time_dict[i] = time

                    # 画图
                    x = self._time_dict[i]
                    y = self._data_dict[i]
                    num = 100 * (len(datax_spectrumtype)) + 10 + i + 1
                    self.draw_a = self.draw.add_subplot(num)
                    strxx = datax_driver + "_" + datax_object + "_" + datax_mode + "_" + datax_power + "_" + datax_group
                    self.draw_a.plot(x, y, color[i], linewidth=1)
                    self.draw_a.legend((name_dict[datax_spectrumtype[i]],), loc='upper left')  # 加一个逗号》》元组类型
                    self.draw_a.set_ylabel("数值")
                    if i == 0:
                        self.draw_a.set_title(strxx)
                    if i == len(datax_spectrumtype) - 1:
                        self.draw_a.set_xlabel("时间(s)")
            # 统计
            self._mean = []
            self._max = []
            self._min = []
            self._std = []
            self._var = []
            for i in range(len(datax_spectrumtype)):
                narray = np.array(self._data_dict[i])
                datamean = np.mean(narray)
                datastd = np.std(narray)
                datavar = np.var(narray)
                datamin = np.min(narray)
                datamax = np.max(narray)
                self._mean.append(datamean)
                self._max.append(datamax)
                self._min.append(datamin)
                self._std.append(datastd)
                self._var.append(datavar)
            self.frm_status_label["text"] = u"Mysql status：查询成功！"
        except MySQLdb.Error:
            self.frm_status_label["text"] = u"Mysql status：查询失败！"

    # 直方图
    def Plot_Hist(self):
        # 画图
        self.draw.clf()
        color = ['b', 'r', 'y', 'g', 'm', 'k', 'c', 'b', 'r', 'y', 'g', 'm', 'k', 'c']
        name_dict = {"PressureGZB": "工作泵压力", "PressureDBDQ": "动臂大腔压力", "PressureDBXQ": "动臂小腔压力",
                     "PressureZZX": "左转向压力", "PressureYZX": "右转向压力", "PressureZDDQ": "转斗大腔压力",
                     "PressureZDXQ": "转斗小腔压力", "PressureZXB": "转向泵压力", "PressureQJD": "前进挡压力",
                     "PressureHTD": "后退挡压力", "PressureF1": "1挡压力", "PressureF2": "2挡压力", "PressureF3": "3挡压力",
                     "PressureF4": "4挡压力", "PressureBSX": "变速箱压力", "PressureQNJ": "前扭矩", "PressureHNJ": "后扭矩",
                     "PressureBJQCK": "变矩器出口压力", "PressureBJQJK": "变矩器进口压力", "Acce1": "加速度1", "Acce2": "加速度2",
                     "Acce3": "加速度3", "SpeedWL": "涡轮转速", "SpeedSCZ": "输出轴转速"}
        for i in range(len(datax_spectrumtype)):
            # 画图
            narray = np.array(self._data_dict[i], dtype=np.float64)
            num = 100 * (len(datax_spectrumtype)) + 10 + i + 1
            self.draw_a = self.draw.add_subplot(num)
            strxx = datax_driver + "_" + datax_object + "_" + datax_mode + "_" + datax_power + "_" + datax_group
            self.draw_a.hist(narray, color=color[i])
            self.draw_a.legend((name_dict[datax_spectrumtype[i]],), loc='upper left')  # 加一个逗号》》元组类型
            self.draw_a.set_ylabel("频次")
            if i == 0:
                self.draw_a.set_title(strxx)
            if i == len(datax_spectrumtype) - 1:
                self.draw_a.set_xlabel("数值")
            self.draw.canvas.show()
            self.frm_status_label["text"] = u"Status：显示直方图！"

    # 时域图
    def Plot_Time(self):
        # 画图
        self.draw.clf()
        color = ['b', 'r', 'y', 'g', 'm', 'k', 'c', 'b', 'r', 'y', 'g', 'm', 'k', 'c']
        name_dict = {"PressureGZB": "工作泵压力", "PressureDBDQ": "动臂大腔压力", "PressureDBXQ": "动臂小腔压力",
                     "PressureZZX": "左转向压力", "PressureYZX": "右转向压力", "PressureZDDQ": "转斗大腔压力",
                     "PressureZDXQ": "转斗小腔压力", "PressureZXB": "转向泵压力", "PressureQJD": "前进挡压力",
                     "PressureHTD": "后退挡压力", "PressureF1": "1挡压力", "PressureF2": "2挡压力", "PressureF3": "3挡压力",
                     "PressureF4": "4挡压力", "PressureBSX": "变速箱压力", "PressureQNJ": "前扭矩", "PressureHNJ": "后扭矩",
                     "PressureBJQCK": "变矩器出口压力", "PressureBJQJK": "变矩器进口压力", "Acce1": "加速度1", "Acce2": "加速度2",
                     "Acce3": "加速度3", "SpeedWL": "涡轮转速", "SpeedSCZ": "输出轴转速"}
        for i in range(len(datax_spectrumtype)):
            # 画图
            x = self._time_dict[i]
            y = self._data_dict[i]
            num = 100 * (len(datax_spectrumtype)) + 10 + i + 1
            self.draw_a = self.draw.add_subplot(num)
            strxx = datax_driver + "_" + datax_object + "_" + datax_mode + "_" + datax_power + "_" + datax_group
            self.draw_a.plot(x, y, color[i], linewidth=1)
            self.draw_a.legend((name_dict[datax_spectrumtype[i]],), loc='upper left')  # 加一个逗号》》元组类型
            self.draw_a.set_ylabel("数值")
            if i == 0:
                self.draw_a.set_title(strxx)
            if i == len(datax_spectrumtype) - 1:
                self.draw_a.set_xlabel("时间(s)")
            self.draw.canvas.show()
        self.frm_status_label["text"] = u"Status：显示时域图！"

    # 时域图1
    def Plot_Time1(self):
        # 画图
        self.draw.clf()
        self.draw_a = self.draw.add_subplot(111)
        color = ['b', 'r', 'y', 'g', 'm', 'k', 'c', 'b', 'r', 'y', 'g', 'm', 'k', 'c']
        name_dict = {"PressureGZB": "工作泵压力", "PressureDBDQ": "动臂大腔压力", "PressureDBXQ": "动臂小腔压力",
                     "PressureZZX": "左转向压力", "PressureYZX": "右转向压力", "PressureZDDQ": "转斗大腔压力",
                     "PressureZDXQ": "转斗小腔压力", "PressureZXB": "转向泵压力", "PressureQJD": "前进挡压力",
                     "PressureHTD": "后退挡压力", "PressureF1": "1挡压力", "PressureF2": "2挡压力", "PressureF3": "3挡压力",
                     "PressureF4": "4挡压力", "PressureBSX": "变速箱压力", "PressureQNJ": "前扭矩", "PressureHNJ": "后扭矩",
                     "PressureBJQCK": "变矩器出口压力", "PressureBJQJK": "变矩器进口压力", "Acce1": "加速度1", "Acce2": "加速度2",
                     "Acce3": "加速度3", "SpeedWL": "涡轮转速", "SpeedSCZ": "输出轴转速"}
        strxxx = []
        for i in range(len(datax_spectrumtype)):
            # 画图
            x = self._time_dict[i]
            y = self._data_dict[i]
            strxx = datax_driver + "_" + datax_object + "_" + datax_mode + "_" + datax_power + "_" + datax_group
            self.draw_a.plot(x, y, color[i], linewidth=1)
            self.draw_a.set_ylabel("数值")
            self.draw_a.set_title(strxx)
            self.draw_a.set_xlabel("时间(s)")
            self.draw.canvas.show()
            strxxx.append(name_dict[datax_spectrumtype[i]])
            if i == 0:
                 self.draw_a.legend( (strxxx[i],), loc='upper left')  # 加一个逗号》》元组类型
            if i == 1:
                   self.draw_a.legend((strxxx[0],strxxx[i],), loc='upper left')  # 加一个逗号》》元组类型
            if i == 2:
                self.draw_a.legend( (strxxx[0], strxxx[1], strxxx[i],), loc='upper left')  # 加一个逗号》》元组类型
            if i == 3:
                self.draw_a.legend((strxxx[0], strxxx[1], strxxx[2], strxxx[i],), loc='upper left')  # 加一个逗号》》元组类型
            if i == 4:
                self.draw_a.legend((strxxx[0], strxxx[1], strxxx[2], strxxx[3],strxxx[i],), loc='upper left')  # 加一个逗号》》元组类型
            if i == 5:
                self.draw_a.legend((strxxx[0], strxxx[1], strxxx[2], strxxx[3], strxxx[4], strxxx[i],), loc='upper left')  # 加一个逗号》》元组类型
            if i == 6:
                self.draw_a.legend((strxxx[0], strxxx[1], strxxx[2], strxxx[3], strxxx[4], strxxx[5], strxxx[i],), loc='upper left')  # 加一个逗号》》元组类型
            if i == 7:
                self.draw_a.legend((strxxx[0], strxxx[1], strxxx[2], strxxx[3], strxxx[4], strxxx[5], strxxx[6], strxxx[i],),
                               loc='upper left')  # 加一个逗号》》元组类型
        self.frm_status_label["text"] = u"Status：显示时域图！"

    # 均值
    def rbtn_mean(self):
        name_dict = {"PressureGZB": "工作泵压力", "PressureDBDQ": "动臂大腔压力", "PressureDBXQ": "动臂小腔压力",
                     "PressureZZX": "左转向压力", "PressureYZX": "右转向压力", "PressureZDDQ": "转斗大腔压力",
                     "PressureZDXQ": "转斗小腔压力", "PressureZXB": "转向泵压力", "PressureQJD": "前进挡压力",
                     "PressureHTD": "后退挡压力", "PressureF1": "1挡压力", "PressureF2": "2挡压力", "PressureF3": "3挡压力",
                     "PressureF4": "4挡压力", "PressureBSX": "变速箱压力", "PressureQNJ": "前扭矩", "PressureHNJ": "后扭矩",
                     "PressureBJQCK": "变矩器出口压力", "PressureBJQJK": "变矩器进口压力", "Acce1": "加速度1", "Acce2": "加速度2",
                     "Acce3": "加速度3", "SpeedWL": "涡轮转速", "SpeedSCZ": "输出轴转速"}
        self.frm_listbox.delete("0", "end")
        for i in range(len(datax_spectrumtype)):
            self.frm_listbox.insert("end", "【均值】" + name_dict[datax_spectrumtype[i]])
            self.frm_listbox.insert("end", str(round(self._mean[i])))

    # 最大值
    def rbtn_max(self):
        name_dict = {"PressureGZB": "工作泵压力", "PressureDBDQ": "动臂大腔压力", "PressureDBXQ": "动臂小腔压力",
                     "PressureZZX": "左转向压力", "PressureYZX": "右转向压力", "PressureZDDQ": "转斗大腔压力",
                     "PressureZDXQ": "转斗小腔压力", "PressureZXB": "转向泵压力", "PressureQJD": "前进挡压力",
                     "PressureHTD": "后退挡压力", "PressureF1": "1挡压力", "PressureF2": "2挡压力", "PressureF3": "3挡压力",
                     "PressureF4": "4挡压力", "PressureBSX": "变速箱压力", "PressureQNJ": "前扭矩", "PressureHNJ": "后扭矩",
                     "PressureBJQCK": "变矩器出口压力", "PressureBJQJK": "变矩器进口压力", "Acce1": "加速度1", "Acce2": "加速度2",
                     "Acce3": "加速度3", "SpeedWL": "涡轮转速", "SpeedSCZ": "输出轴转速"}
        self.frm_listbox.delete("0", "end")
        for i in range(len(datax_spectrumtype)):
            self.frm_listbox.insert("end", "【最大值】" + name_dict[datax_spectrumtype[i]])
            self.frm_listbox.insert("end", str(round(self._max[i])))

    # 最小值
    def rbtn_min(self):
        name_dict = {"PressureGZB": "工作泵压力", "PressureDBDQ": "动臂大腔压力", "PressureDBXQ": "动臂小腔压力",
                     "PressureZZX": "左转向压力", "PressureYZX": "右转向压力", "PressureZDDQ": "转斗大腔压力",
                     "PressureZDXQ": "转斗小腔压力", "PressureZXB": "转向泵压力", "PressureQJD": "前进挡压力",
                     "PressureHTD": "后退挡压力", "PressureF1": "1挡压力", "PressureF2": "2挡压力", "PressureF3": "3挡压力",
                     "PressureF4": "4挡压力", "PressureBSX": "变速箱压力", "PressureQNJ": "前扭矩", "PressureHNJ": "后扭矩",
                     "PressureBJQCK": "变矩器出口压力", "PressureBJQJK": "变矩器进口压力", "Acce1": "加速度1", "Acce2": "加速度2",
                     "Acce3": "加速度3", "SpeedWL": "涡轮转速", "SpeedSCZ": "输出轴转速"}
        self.frm_listbox.delete("0", "end")
        for i in range(len(datax_spectrumtype)):
            self.frm_listbox.insert("end", "【最小值】" + name_dict[datax_spectrumtype[i]])
            self.frm_listbox.insert("end", str(round(self._min[i])))

    # 标准差
    def rbtn_std(self):
        name_dict = {"PressureGZB": "工作泵压力", "PressureDBDQ": "动臂大腔压力", "PressureDBXQ": "动臂小腔压力",
                     "PressureZZX": "左转向压力", "PressureYZX": "右转向压力", "PressureZDDQ": "转斗大腔压力",
                     "PressureZDXQ": "转斗小腔压力", "PressureZXB": "转向泵压力", "PressureQJD": "前进挡压力",
                     "PressureHTD": "后退挡压力", "PressureF1": "1挡压力", "PressureF2": "2挡压力", "PressureF3": "3挡压力",
                     "PressureF4": "4挡压力", "PressureBSX": "变速箱压力", "PressureQNJ": "前扭矩", "PressureHNJ": "后扭矩",
                     "PressureBJQCK": "变矩器出口压力", "PressureBJQJK": "变矩器进口压力", "Acce1": "加速度1", "Acce2": "加速度2",
                     "Acce3": "加速度3", "SpeedWL": "涡轮转速", "SpeedSCZ": "输出轴转速"}
        self.frm_listbox.delete("0", "end")
        for i in range(len(datax_spectrumtype)):
            self.frm_listbox.insert("end", "【标准差】" + name_dict[datax_spectrumtype[i]])
            self.frm_listbox.insert("end", str(round(self._std[i])))

    # 方差
    def rbtn_var(self):
        name_dict = {"PressureGZB": "工作泵压力", "PressureDBDQ": "动臂大腔压力", "PressureDBXQ": "动臂小腔压力",
                     "PressureZZX": "左转向压力", "PressureYZX": "右转向压力", "PressureZDDQ": "转斗大腔压力",
                     "PressureZDXQ": "转斗小腔压力", "PressureZXB": "转向泵压力", "PressureQJD": "前进挡压力",
                     "PressureHTD": "后退挡压力", "PressureF1": "1挡压力", "PressureF2": "2挡压力", "PressureF3": "3挡压力",
                     "PressureF4": "4挡压力", "PressureBSX": "变速箱压力", "PressureQNJ": "前扭矩", "PressureHNJ": "后扭矩",
                     "PressureBJQCK": "变矩器出口压力", "PressureBJQJK": "变矩器进口压力", "Acce1": "加速度1", "Acce2": "加速度2",
                     "Acce3": "加速度3", "SpeedWL": "涡轮转速", "SpeedSCZ": "输出轴转速"}
        self.frm_listbox.delete("0", "end")
        for i in range(len(datax_spectrumtype)):
            self.frm_listbox.insert("end", "【方差】" + name_dict[datax_spectrumtype[i]])
            self.frm_listbox.insert("end", str(round(self._var[i])))



# 车辆数据导入
class Loader_Import(tk.Toplevel):
    # 初始化函数
    def __init__(self, master=None):
        tk.Toplevel.__init__(self)
        self.original_frame = master
        self.resizable(False, False)
        self.title("车辆信息导入")
        self.mysql_connect()
        self.create_frame()

    # 总体框架【上下】
    def create_frame(self):
        self.frm = pytk.PyLabelFrame(self)
        self.frm_status = pytk.PyLabelFrame(self)

        self.frm.grid(row=0, column=0, sticky="wesn")
        self.frm_status.grid(row=1, column=0, sticky="wesn")

        self.create_frm()
        self.create_frm_status()

    # 总体框架【左右】
    def create_frm(self):
        '''
        上半部分窗口分为左右2个部分
        '''
        self.frm_left = pytk.PyLabelFrame(self.frm)
        self.frm_right = pytk.PyLabelFrame(self.frm)

        self.frm_left.grid(row=0, column=0, padx=5, pady=5, sticky="wesn")
        self.frm_right.grid(row=0, column=1, padx=5, pady=5, sticky="wesn")

        self.create_frm_left()
        self.create_frm_right()

    # 框架【左】
    def create_frm_left(self):
        self.frm_left_car = pytk.PyLabelFrame(self.frm_left)

        self.frm_right_engine = pytk.PyLabelFrame(self.frm_left)

        self.frm_left_car.grid(row=0, column=0, padx=20, pady=15, sticky="wesn")
        self.frm_right_engine.grid(row=1, column=0, padx=20, pady=20, sticky="wesn")
        self.create_frm_right_engine()
        self.create_frm_left_car()

    # 框架 车
    def create_frm_left_car(self):
        self.frm_left_car_label = pytk.PyLabel(self.frm_left_car,
                                               text="车辆参数",
                                               font=("Times", 25))
        self.frm_left_car_carfrm = pytk.PyLabelFrame(self.frm_left_car)
        self.frm_left_car_enginefrm = pytk.PyLabelFrame(self.frm_left_car)
        self.frm_left_car_turbinefrm = pytk.PyLabelFrame(self.frm_left_car)
        self.frm_left_car_gearfrm = pytk.PyLabelFrame(self.frm_left_car)
        self.frm_left_car_carframefrm = pytk.PyLabelFrame(self.frm_left_car)
        self.frm_left_car_btnimport = pytk.PyButton(self.frm_left_car,
                                                    text="车辆参数导入",
                                                    font=g_font,
                                                    command=self.btn_carinformation)

        self.frm_left_car_label.grid(row=0, column=0, sticky="wsne")
        self.frm_left_car_carfrm.grid(row=1, column=0, sticky="wsne")
        self.frm_left_car_enginefrm.grid(row=2, column=0, sticky="wsne")
        self.frm_left_car_turbinefrm.grid(row=3, column=0, sticky="wsne")
        self.frm_left_car_gearfrm.grid(row=4, column=0, sticky="wsne")
        self.frm_left_car_carframefrm.grid(row=5, column=0, sticky="wsne")
        self.frm_left_car_btnimport.grid(row=6, column=0, padx=70, sticky="wsne")

        self.frm_left_car_carfrm_label = pytk.PyLabel(self.frm_left_car_carfrm, text="车辆型号：",
                                                      font=("Times", 15))
        self.frm_left_car_carfrm_entry = pytk.PyEntry(self.frm_left_car_carfrm, width=enty_width,
                                                      font=("Times", 15))
        self.frm_left_car_carfrm_label.grid(row=0, column=0, sticky="w")
        self.frm_left_car_carfrm_entry.grid(row=1, column=0, sticky="w")

        self.frm_left_car_turbinefrm_label = pytk.PyLabel(self.frm_left_car_turbinefrm, text="液力变矩器型号：",
                                                          font=("Times", 15))
        self.frm_left_car_turbinefrm_label.grid(row=0, column=0, sticky="w")
        self._var2 = tk.StringVar()
        self.frm_left_car_turbinefrm_optionmenu = tk.OptionMenu(self.frm_left_car_turbinefrm, self._var2, *self._listturbine)
        self.frm_left_car_turbinefrm_optionmenu.config(font=('Times', 15), bg="#292929", fg="#E0EEEE", width = 26)
        self.frm_left_car_turbinefrm_optionmenu.grid(row=1, column=0, sticky="wsne")


        self.frm_left_car_enginefrm_label = pytk.PyLabel(self.frm_left_car_enginefrm, text="发动机型号：",
                                                         font=("Times", 15))
        self.frm_left_car_enginefrm_label.grid(row=0, column=0, sticky="w")
        self._var1 = tk.StringVar()
        self.frm_left_car_enginefrm_optionmenu = tk.OptionMenu(self.frm_left_car_enginefrm, self._var1, *self._listengine)
        self.frm_left_car_enginefrm_optionmenu.config(font=('Times', 15), bg="#292929", fg="#E0EEEE", width=26)
        self.frm_left_car_enginefrm_optionmenu.grid(row=1, column=0, sticky="wsne")

        self.frm_left_car_gearfrm_label = pytk.PyLabel(self.frm_left_car_gearfrm, text="变速箱型号：",
                                                       font=("Times", 15))
        self.frm_left_car_gearfrm_label.grid(row=0, column=0, sticky="w")
        self._var3 = tk.StringVar()
        self.frm_left_car_gearfrm_optionmenu = tk.OptionMenu(self.frm_left_car_gearfrm, self._var3, *self._listgear)
        self.frm_left_car_gearfrm_optionmenu.config(font=('Times', 15), bg="#292929", fg="#E0EEEE", width=26)
        self.frm_left_car_gearfrm_optionmenu.grid(row=1, column=0, sticky="wsne")

        self.frm_left_car_carframefrm_label = pytk.PyLabel(self.frm_left_car_carframefrm, text="车架型号：",
                                                           font=("Times", 15))
        self.frm_left_car_carframefrm_label.grid(row=0, column=0, sticky="w")
        self._var4 = tk.StringVar()
        self.frm_left_car_carframefrm_optionmenu = tk.OptionMenu(self.frm_left_car_carframefrm, self._var4, *self._listcarframe)
        self.frm_left_car_carframefrm_optionmenu.config(font=('Times', 15), bg="#292929", fg="#E0EEEE", width=26)
        self.frm_left_car_carframefrm_optionmenu.grid(row=1, column=0, sticky="wsne")

    # 框架 发动机
    def create_frm_right_engine(self):
        self.frm_right_engine_label = pytk.PyLabel(self.frm_right_engine,
                                                   text="发动机参数",
                                                   font=("Times", 25))
        self.frm_right_engine_namefrm = pytk.PyLabelFrame(self.frm_right_engine)
        self.frm_right_btn_engine = pytk.PyButton(self.frm_right_engine,
                                                  text="发动机参数导入",
                                                  font=g_font,
                                                  command=self.btn_engineinformation)
        self.frm_right_engine_namefrm1 = pytk.PyLabelFrame(self.frm_right_engine)
        self.frm_right_engine_namefrm2 = pytk.PyLabelFrame(self.frm_right_engine)
        self.frm_right_btn_enginecharcater = pytk.PyButton(self.frm_right_engine,
                                                           text="发动机特性曲线导入",
                                                           font=g_font,
                                                           command=self.btn_enginecharacter)

        self.frm_right_engine_label.grid(row=0, column=0, sticky="wsne")
        self.frm_right_engine_namefrm.grid(row=1, column=0, sticky="wsne")
        self.frm_right_engine_namefrm1.grid(row=3, column=0, sticky="wsne")
        self.frm_right_btn_engine.grid(row=2, column=0, padx=70, sticky="wsne")
        self.frm_right_engine_namefrm2.grid(row=4, column=0, sticky="wsne")
        self.frm_right_btn_enginecharcater.grid(row=5, column=0, padx=70, sticky="wsne")

        self.frm_right_engine_namefrm_label = pytk.PyLabel(self.frm_right_engine_namefrm, text="发动机型号：",
                                                           font=("Times", 15))
        self.frm_right_engine_namefrm_entry = pytk.PyEntry(self.frm_right_engine_namefrm, width=enty_width,
                                                           font=("Times", 15))
        self.frm_right_engine_namefrm_label.grid(row=0, column=0, sticky="w")
        self.frm_right_engine_namefrm_entry.grid(row=1, column=0, sticky="w")

        self.frm_right_engine_namefrm_label1 = pytk.PyLabel(self.frm_right_engine_namefrm1, text="发动机型号：",
                                                           font=("Times", 15))
        self._var5 = tk.StringVar()
        self.frm_right_engine_namefrm_optionmenu = tk.OptionMenu(self.frm_right_engine_namefrm1, self._var5, *self._listengine)
        self.frm_right_engine_namefrm_optionmenu.config(font=('Times', 15), bg="#292929", fg="#E0EEEE", width = 26)
        self.frm_right_engine_namefrm_label1.grid(row=0, column=0, sticky="w")
        self.frm_right_engine_namefrm_optionmenu.grid(row=1, column=0, sticky="wsne")

        self.frm_right_engine_namefrm_label2 = pytk.PyLabel(self.frm_right_engine_namefrm2, text="实验组别：",
                                                           font=("Times", 15))
        self.frm_right_engine_namefrm_entry2 = pytk.PyEntry(self.frm_right_engine_namefrm2, width=enty_width,
                                                           font=("Times", 15))
        self.frm_right_engine_namefrm_label2.grid(row=0, column=0, sticky="w")
        self.frm_right_engine_namefrm_entry2.grid(row=1, column=0, sticky="w")

    # 退出
    def create_frm_left_back(self):
        self.frm_left_btn_back = pytk.PyButton(self.frm_left_back,
                                               text="返回主菜单",
                                               font=g_font,
                                               command=self.Back_main_menu)
        self.frm_left_btn_back.grid(row=3, column=0, padx=100, sticky="wesn")

    # 框架 右
    def create_frm_right(self):
        self.frm_right_turbine = pytk.PyLabelFrame(self.frm_right)
        self.frm_right_gear = pytk.PyLabelFrame(self.frm_right)
        self.frm_right_carframe = pytk.PyLabelFrame(self.frm_right)
        self.frm_left_back = pytk.PyLabelFrame(self.frm_right)
        self.frm_right_turbine.grid(row=0, column=0, padx=20, pady=20, sticky="wesn")
        self.frm_right_gear.grid(row=1, column=0, padx=20, pady=20, sticky="wesn")
        self.frm_right_carframe.grid(row=2, column=0, padx=20, pady=20, sticky="wesn")
        self.frm_left_back.grid(row=3, column=0, padx=20, pady=25, sticky="wesn")
        self.create_frm_right_turbine()
        self.create_frm_right_gear()
        self.create_frm_right_carframe()
        self.create_frm_left_back()

    # 框架 液力变矩器
    def create_frm_right_turbine(self):
        self.frm_right_turbine_label = pytk.PyLabel(self.frm_right_turbine,
                                                    text="液力变矩器参数",
                                                    font=("Times", 25))
        self.frm_right_turbine_namefrm = pytk.PyLabelFrame(self.frm_right_turbine)
        self.frm_right_turbine_namefrm1 = pytk.PyLabelFrame(self.frm_right_turbine)
        self.frm_right_turbine_namefrm2 = pytk.PyLabelFrame(self.frm_right_turbine)
        self.frm_right_btn_turbine = pytk.PyButton(self.frm_right_turbine,
                                                   text="液力变矩器参数导入",
                                                   font=g_font,
                                                   command=self.btn_turbineinformation)
        self.frm_right_btn_turbinecharcater = pytk.PyButton(self.frm_right_turbine,
                                                            text="变矩器特性曲线导入",
                                                            font=g_font,
                                                            command=self.btn_turbinecharacter)
        self.frm_right_btn_traction = pytk.PyButton(self.frm_right_turbine,
                                                    text="驱动功率与牵引力曲线",
                                                    font=g_font,
                                                    command=self.btn_turbinetraction)

        self.frm_right_turbine_label.grid(row=0, column=0, sticky="wsne")
        self.frm_right_turbine_namefrm.grid(row=1, column=0, sticky="wsne")
        self.frm_right_btn_turbine.grid(row=2, column=0, padx=65, sticky="wnse")
        self.frm_right_turbine_namefrm1.grid(row=3, column=0, sticky="wsne")
        self.frm_right_btn_turbinecharcater.grid(row=5, column=0, padx=65, sticky="wnse")
        self.frm_right_turbine_namefrm2.grid(row=4, column=0, sticky="wsne")
        self.frm_right_btn_traction.grid(row=6, column=0, padx=65, sticky="wnse")

        self.frm_right_turbine_namefrm_label = pytk.PyLabel(self.frm_right_turbine_namefrm, text="液力变矩器型号：",
                                                            font=("Times", 15))
        self.frm_right_turbine_namefrm_entry = pytk.PyEntry(self.frm_right_turbine_namefrm, font=("Times", 15),
                                                            width=enty_width)
        self.frm_right_turbine_namefrm_label.grid(row=0, column=0, sticky="w")
        self.frm_right_turbine_namefrm_entry.grid(row=1, column=0, sticky="w")

        self.frm_right_turbine_namefrm_label1 = pytk.PyLabel(self.frm_right_turbine_namefrm1, text="液力变矩器型号：",
                                                           font=("Times", 15))
        self._var6 = tk.StringVar()
        self.frm_right_turbine_namefrm_optionmenu = tk.OptionMenu(self.frm_right_turbine_namefrm1, self._var6, *self._listturbine)
        self.frm_right_turbine_namefrm_optionmenu.config(font=('Times', 15), bg="#292929", fg="#E0EEEE", width = 26)
        self.frm_right_turbine_namefrm_label1.grid(row=0, column=0, sticky="w")
        self.frm_right_turbine_namefrm_optionmenu.grid(row=1, column=0, sticky="wsne")

        self.frm_right_turbine_namefrm_label2 = pytk.PyLabel(self.frm_right_turbine_namefrm2, text="实验组别：",
                                                            font=("Times", 15))
        self.frm_right_turbine_namefrm_entry2 = pytk.PyEntry(self.frm_right_turbine_namefrm2, font=("Times", 15),
                                                            width=enty_width)
        self.frm_right_turbine_namefrm_label2.grid(row=0, column=0, sticky="w")
        self.frm_right_turbine_namefrm_entry2.grid(row=1, column=0, sticky="w")

    # 框架 齿轮箱
    def create_frm_right_gear(self):
        self.frm_right_gear_label = pytk.PyLabel(self.frm_right_gear,
                                                 text="变速箱参数",
                                                 font=("Times", 25))
        self.frm_right_gear_namefrm = pytk.PyLabelFrame(self.frm_right_gear)
        self.frm_right_btn_gear = pytk.PyButton(self.frm_right_gear,
                                                text="变速箱参数导入",
                                                font=g_font,
                                                command=self.btn_gearinformation)

        self.frm_right_gear_label.grid(row=0, column=0, sticky="wsne")
        self.frm_right_gear_namefrm.grid(row=1, column=0, sticky="wsne")
        self.frm_right_btn_gear.grid(row=2, column=0, padx=70, sticky="wnse")

        self.frm_right_gear_namefrm_label = pytk.PyLabel(self.frm_right_gear_namefrm, text="变速箱型号：",
                                                         font=("Times", 15))
        self.frm_right_gear_namefrm_entry = pytk.PyEntry(self.frm_right_gear_namefrm, width=enty_width,
                                                         font=("Times", 15))
        self.frm_right_gear_namefrm_label.grid(row=0, column=0, sticky="w")
        self.frm_right_gear_namefrm_entry.grid(row=1, column=0, sticky="w")

    # 框架 车架
    def create_frm_right_carframe(self):
        self.frm_right_carframe_label = pytk.PyLabel(self.frm_right_carframe,
                                                     text="车架参数",
                                                     font=("Times", 25))
        self.frm_right_carframe_namefrm = pytk.PyLabelFrame(self.frm_right_carframe)
        self.frm_right_btn_carframe = pytk.PyButton(self.frm_right_carframe,
                                                    text="车架参数导入",
                                                    font=g_font,
                                                    command=self.btn_carframeinformation)

        self.frm_right_carframe_label.grid(row=0, column=0, sticky="wsne")
        self.frm_right_carframe_namefrm.grid(row=1, column=0, sticky="wsne")
        self.frm_right_btn_carframe.grid(row=3, column=0, padx=70, sticky="wnse")

        self.frm_right_carframe_namefrm_label = pytk.PyLabel(self.frm_right_carframe_namefrm, text="车架型号：",
                                                             font=("Times", 15))
        self.frm_right_carframe_namefrm_entry = pytk.PyEntry(self.frm_right_carframe_namefrm, width=enty_width,
                                                             font=("Times", 15))
        self.frm_right_carframe_namefrm_label.grid(row=0, column=0, sticky="w")
        self.frm_right_carframe_namefrm_entry.grid(row=1, column=0, sticky="w")

    # 框架 状态栏
    def create_frm_status(self):
        self.frm_status_label = pytk.PyLabel(self.frm_status,
                                             text="Mysql status：已连接到loaderdb",
                                             font=g_font)
        self.frm_status_label.grid(row=0, column=0, padx=5, pady=5, sticky="wesn")

    # Mysql连接
    def mysql_connect(self):
        try:
            conn.select_db('loaderdb')
            # 发动机
            sql_engine = "SELECT EngineName FROM engineinfo"
            cur = conn.cursor()
            cur.execute(sql_engine)
            stus = cur.fetchall()
            conn.commit()
            cur.close()
            self._listengine = []
            if stus:
                for i in range(len(stus)):
                    name = stus[i]["EngineName"]
                    self._listengine.append(name)
            else:
                self._listengine.append("NULL")

            # 液力变矩器
            sql_turbine = "SELECT TurbineName FROM turbineinfo"
            cur = conn.cursor()
            cur.execute(sql_turbine)
            stus = cur.fetchall()
            conn.commit()
            cur.close()
            self._listturbine = []
            if stus:
                for i in range(len(stus)):
                    name = stus[i]["TurbineName"]
                    self._listturbine.append(name)
            else:
                self._listturbine.append("NULL")

            # 齿轮箱
            sql_gear = "SELECT GearName FROM gearinfo"
            cur = conn.cursor()
            cur.execute(sql_gear)
            stus = cur.fetchall()
            conn.commit()
            cur.close()
            self._listgear = []
            if stus:
                for i in range(len(stus)):
                    name = stus[i]["GearName"]
                    self._listgear.append(name)
            else:
                self._listgear.append("NULL")

            # 车架
            sql_carframe = "SELECT CarframeName FROM carframeinfo"
            cur = conn.cursor()
            cur.execute(sql_carframe)
            stus = cur.fetchall()
            conn.commit()
            cur.close()
            self._listcarframe = []
            if stus:
                for i in range(len(stus)):
                    name = stus[i]["CarframeName"]
                    self._listcarframe.append(name)
            else:
                self._listcarframe.append("NULL")
        except MySQLdb.Error, e:
            tkMessageBox.showinfo("状态：", u"MySQL Error： %d:%s" % (e.args[0], e.args[1]))
            self.frm_status_label["text"] = u"MySQL Error： 数据库连接错误！"

    # Update MENU
    def Updatex(self):
        self.frm_left_car_turbinefrm_optionmenu = tk.OptionMenu(self.frm_left_car_turbinefrm, self._var1, *self._listturbine)
        self.frm_left_car_turbinefrm_optionmenu.config(font=('Times', 15), bg="#292929", fg="#E0EEEE", width = 26)
        self.frm_left_car_turbinefrm_optionmenu.grid(row=1, column=0, sticky="wsne")

        self.frm_left_car_enginefrm_optionmenu = tk.OptionMenu(self.frm_left_car_enginefrm, self._var2, *self._listengine)
        self.frm_left_car_enginefrm_optionmenu.config(font=('Times', 15), bg="#292929", fg="#E0EEEE", width=26)
        self.frm_left_car_enginefrm_optionmenu.grid(row=1, column=0, sticky="wsne")

        self.frm_left_car_gearfrm_optionmenu = tk.OptionMenu(self.frm_left_car_gearfrm, self._var3, *self._listgear)
        self.frm_left_car_gearfrm_optionmenu.config(font=('Times', 15), bg="#292929", fg="#E0EEEE", width=26)
        self.frm_left_car_gearfrm_optionmenu.grid(row=1, column=0, sticky="wsne")

        self.frm_left_car_carframefrm_optionmenu = tk.OptionMenu(self.frm_left_car_carframefrm, self._var4, *self._listcarframe)
        self.frm_left_car_carframefrm_optionmenu.config(font=('Times', 15), bg="#292929", fg="#E0EEEE", width=26)
        self.frm_left_car_carframefrm_optionmenu.grid(row=1, column=0, sticky="wsne")

        self.frm_right_engine_namefrm_optionmenu = tk.OptionMenu(self.frm_right_engine_namefrm1, self._var5, *self._listengine)
        self.frm_right_engine_namefrm_optionmenu.config(font=('Times', 15), bg="#292929", fg="#E0EEEE", width = 26)
        self.frm_right_engine_namefrm_optionmenu.grid(row=1, column=0, sticky="wsne")

        self.frm_right_turbine_namefrm_optionmenu = tk.OptionMenu(self.frm_right_turbine_namefrm1, self._var6,*self._listturbine)
        self.frm_right_turbine_namefrm_optionmenu.config(font=('Times', 15), bg="#292929", fg="#E0EEEE", width=26)
        self.frm_right_turbine_namefrm_optionmenu.grid(row=1, column=0, sticky="wsne")

    # 返回主菜单
    def Back_main_menu(self):
        self.withdraw()
        MainWindow(self)

    # 车辆信息导入
    def btn_carinformation(self):
        try:
            cur = conn.cursor()
            data_engine = str(self._var1.get())
            data_turbine = str(self._var2.get())
            data_gear = str(self._var3.get())
            data_carframe = str(self._var4.get())
            data_car = str(self.frm_left_car_carfrm_entry.get())
            # 判断字符串非空
            if data_car:
                # 插入
                sql_insert = "INSERT INTO carinfo (CarName, TurbineName, EngineName, GearName, CarframeName) VALUES ('{0}','{1}','{2}', '{3}', '{4}')".format(data_car, data_turbine, data_engine, data_gear, data_carframe)
                cur.execute(sql_insert)
                conn.commit()
                tkMessageBox.showinfo("提示", u"车辆参数信息导入成功")
                self.frm_status_label["text"] = "Mysql status：车辆参数信息导入成功！"
            else:
                tkMessageBox.showinfo("提示", u"请输入车辆类型信息！")
        except MySQLdb.Error, e:
            tkMessageBox.showinfo("Mysql错误", u"%s" % (e.args[1]))

    # 发动机信息导入
    def btn_engineinformation(self):
        try:
            # 游标
            cur = conn.cursor()
            # 插入engineinfo
            data_engine = self.frm_right_engine_namefrm_entry.get()  # 发动机型号
            # 判断字符串非空
            if data_engine:
                # 判断filename非空
                filename = tkFileDialog.askopenfilename(
                    filetypes=[("EXCEL file", "*.xlsx"), ("EXCEL file", "*.xls")])
                if filename:
                    # 插入engineinfo
                    sql_engineinfo = "INSERT INTO engineinfo (EngineName, RatedPower, RatedSpeed,MaxTorqueSpeed, " \
                                     "MaxTorque,NumCylinder, DCylinder, PistonStroke,PistonDisplacement,CompressionRatio," \
                                     " Lengthx, Width, Height, Weight,MaxTorquePower,MaxPower,MaxPowerTorque,MaxPowerSpeed,nEngine)" \
                                     " VALUES (%s,%s, %s,%s, %s,%s, %s,%s, %s,%s, %s,%s, %s,%s,%s,%s,%s,%s,%s)"
                    data = xlrd.open_workbook(filename)
                    table = data.sheets()[0]
                    tabledict = table.row_values(1)
                    tabledict.insert(0, data_engine)
                    param02 = tuple(tabledict)
                    # 插入数据
                    cur.execute(sql_engineinfo, param02)
                    conn.commit()
                    self.frm_status_label["text"] = "Mysql status：发动机信息导入成功！"
                    tkMessageBox.showinfo("提示", u"发动机信息导入成功！")
                    self.mysql_connect()
                    self.Updatex()
                else:
                    tkMessageBox.showinfo("提示", u"请选择Excel表格！")
            else:
                tkMessageBox.showinfo("提示", u"请输入发动机类型信息！")
        except MySQLdb.Error, e:
            tkMessageBox.showinfo("Mysql错误", u"%s" % (e.args[1]))

    # 发动机特性曲线导入
    def btn_enginecharacter(self):
        try:
            cur = conn.cursor()
            data_engine = self._var5.get()
            data_groupx = self.frm_right_engine_namefrm_entry2.get()
            # 判断字符串非空
            if data_engine:
                # 判断filename非空
                filename = tkFileDialog.askopenfilename(
                    filetypes=[("EXCEL file", "*.xlsx"), ("EXCEL file", "*.xls")])
                if filename:
                    # 插入
                    sql_insert = "INSERT INTO enginecurve (EngineName, EngineGroupx, Me, P, ge, n) VALUES (%s, %s,%s, %s, %s, %s)"
                    # 删除
                    sql_delete = "DELETE FROM enginecurve WHERE EngineName = '{0}' AND EngineGroupx = '{1}'".format(data_engine, data_groupx)

                    cur.execute(sql_delete)
                    conn.commit()

                    data = xlrd.open_workbook(filename)
                    table = data.sheets()[0]
                    nrows = table.nrows
                    tabledict = {}
                    for i in range(2, nrows):  # 第二列起读
                        tabledict[i] = table.row_values(i)
                        tabledict[i].insert(0, data_groupx)
                        tabledict[i].insert(0, data_engine)
                    param01 = []
                    for i in range(2, nrows):  # 列表转元组，tabledict[i], 通过添加数据到列表中，然后再转为元组，因为元组是不可改的。
                        param01.append(tuple(tabledict[i]))
                    param02 = tuple(param01)
                    # 插入数据
                    cur.executemany(sql_insert, param02)
                    conn.commit()
                    tkMessageBox.showinfo("提示", u"发动机特性曲线导入成功")
                    self.frm_status_label["text"] = "Mysql status：发动机特性曲线导入成功！"
                else:
                    tkMessageBox.showinfo("提示", u"请选择Excel表格！")
            else:
                tkMessageBox.showinfo("提示", u"请输入发动机类型信息！")
        except MySQLdb.Error, e:
            tkMessageBox.showinfo("Mysql错误", u"%s" % (e.args[1]))

    # 液力变矩器信息导入
    def btn_turbineinformation(self):
        try:
            # 游标
            cur = conn.cursor()
            # 插入turbineinfo
            data_turbine = self.frm_right_turbine_namefrm_entry.get()  # 液力变矩器型号
            # 判断字符串非空
            if data_turbine:
                # 判断filename非空
                filename = tkFileDialog.askopenfilename(
                    filetypes=[("EXCEL file", "*.xlsx"), ("EXCEL file", "*.xls")])
                if filename:
                    # 插入turbineinfo
                    sql_turbineinfo = "INSERT INTO turbineinfo (TurbineName, TurbineD, TurbineRatedSpeed, " \
                                      "TurbineMaxTorque, TurbineRatedPower,ITurbine) VALUES (%s, %s,%s, %s,%s,%s)"
                    data = xlrd.open_workbook(filename)
                    table = data.sheets()[0]
                    tabledict = table.row_values(1)
                    tabledict.insert(0, data_turbine)
                    param02 = tuple(tabledict)
                    # 插入数据
                    cur.execute(sql_turbineinfo, param02)
                    conn.commit()
                    self.frm_status_label["text"] = "Mysql status：液力变矩器信息导入成功！"
                    tkMessageBox.showinfo("提示", u"液力变矩器信息导入成功！")
                    self.mysql_connect()
                    self.Updatex()
                else:
                    tkMessageBox.showinfo("提示", u"请选择Excel表格！")
            else:
                tkMessageBox.showinfo("提示", u"请输入液力变矩器类型信息！")
        except MySQLdb.Error, e:
            tkMessageBox.showinfo("Mysql错误", u"%s" % (e.args[1]))

    # 液力变矩器特性曲线导入
    def btn_turbinecharacter(self):
        try:
            cur = conn.cursor()
            data_turbine = self._var6.get()
            data_groupx = self.frm_right_turbine_namefrm_entry2.get()
            # 判断字符串非空
            if data_turbine:
                # 判断filename非空
                filename = tkFileDialog.askopenfilename(
                    filetypes=[("EXCEL file", "*.xlsx"), ("EXCEL file", "*.xls")])
                if filename:
                    # 插入
                    sql_insert = "INSERT INTO turbinecurve (TurbineName, TurbineGroupx, K, i, nt, Mt, lamda) VALUES (%s, %s,%s, %s, %s, %s, %s)"
                    # 删除
                    sql_delete = "DELETE FROM turbinecurve WHERE TurbineName = '{0}' AND TurbineGroupx = '{1}'".format(
                        data_turbine, data_groupx)

                    cur.execute(sql_delete)
                    conn.commit()

                    data = xlrd.open_workbook(filename)
                    table = data.sheets()[0]
                    nrows = table.nrows
                    tabledict = {}
                    for i in range(2, nrows):  # 第二列起读
                        tabledict[i] = table.row_values(i)
                        tabledict[i].insert(0, data_groupx)
                        tabledict[i].insert(0, data_turbine)
                    param01 = []
                    for i in range(2, nrows):  # 列表转元组，tabledict[i], 通过添加数据到列表中，然后再转为元组，因为元组是不可改的。
                        param01.append(tuple(tabledict[i]))
                    param02 = tuple(param01)
                    # 插入数据
                    cur.executemany(sql_insert, param02)
                    conn.commit()
                    tkMessageBox.showinfo("提示", u"液力变矩器特性曲线导入成功")
                    self.frm_status_label["text"] = "Mysql status：液力变矩器特性曲线导入成功！"
                else:
                    tkMessageBox.showinfo("提示", u"请选择Excel表格！")
            else:
                tkMessageBox.showinfo("提示", u"请选择液力变矩器类型！")
        except MySQLdb.Error, e:
            tkMessageBox.showinfo("Mysql错误", u"%s" % (e.args[1]))

    # 牵引力特性曲线导入
    def btn_turbinetraction(self):
        try:
            cur = conn.cursor()
            data_turbine = self._var6.get()
            data_groupx = self.frm_right_turbine_namefrm_entry2.get()
            # 判断字符串非空
            if data_turbine:
                # 判断filename非空
                filename = tkFileDialog.askopenfilename(
                    filetypes=[("EXCEL file", "*.xlsx"), ("EXCEL file", "*.xls")])
                if filename:
                    # 插入
                    sql_insert = "INSERT INTO tractionefficiency (TurbineName,TractionGroupx, VF1, FF1, GradientF1, alphaF1, VF2, FF2, GradientF2, alphaF2, VF3, FF3, GradientF3, alphaF3, VF4, FF4, GradientF4, alphaF4, efficiency) VALUES (%s, %s,%s, %s, %s, %s, %s, %s, %s,%s, %s, %s, %s, %s,%s,%s,%s,%s,%s)"
                    # 删除
                    sql_delete = "DELETE FROM tractionefficiency WHERE TurbineName = '{0}' AND TractionGroupx = '{1}'".format(
                        data_turbine, data_groupx)

                    cur.execute(sql_delete)
                    conn.commit()

                    data = xlrd.open_workbook(filename)
                    table = data.sheets()[0]
                    nrows = table.nrows
                    tabledict = {}
                    for i in range(2, nrows):  # 第二列起读
                        tabledict[i] = table.row_values(i)
                        tabledict[i].insert(0, data_groupx)
                        tabledict[i].insert(0, data_turbine)
                    param01 = []
                    for i in range(2, nrows):  # 列表转元组，tabledict[i], 通过添加数据到列表中，然后再转为元组，因为元组是不可改的。
                        param01.append(tuple(tabledict[i]))
                    param02 = tuple(param01)
                    # 插入数据
                    cur.executemany(sql_insert, param02)
                    conn.commit()
                    tkMessageBox.showinfo("提示", u"牵引力特性曲线导入成功")
                    self.frm_status_label["text"] = "Mysql status：牵引力特性曲线导入成功！"
                else:
                    tkMessageBox.showinfo("提示", u"请选择Excel表格！")
            else:
                tkMessageBox.showinfo("提示", u"请选择液力变矩器类型！")
        except MySQLdb.Error, e:
            tkMessageBox.showinfo("Mysql错误", u"%s" % (e.args[1]))

    # 变速箱导入
    def btn_gearinformation(self):
        try:
            # 游标
            cur = conn.cursor()
            # 插入engineinfo
            data_gear = self.frm_right_gear_namefrm_entry.get()  # 变速箱型号
            # 判断字符串非空
            if data_gear:
                # 判断filename非空
                filename = tkFileDialog.askopenfilename(
                    filetypes=[("EXCEL file", "*.xlsx"), ("EXCEL file", "*.xls")])
                if filename:
                    # 插入gearinfo
                    sql_gearinfo = "INSERT INTO gearinfo (GearName, F1, F2, F3, F4, R1, R2, R3,nGear) VALUES (%s, %s,%s, %s, %s, %s,%s, %s,%s)"
                    data = xlrd.open_workbook(filename)
                    table = data.sheets()[0]
                    tabledict = table.row_values(1)
                    tabledict.insert(0, data_gear)
                    param02 = tuple(tabledict)
                    # 插入数据
                    cur.execute(sql_gearinfo, param02)
                    conn.commit()
                    self.frm_status_label["text"] = "Mysql status：变速箱信息导入成功！"
                    tkMessageBox.showinfo("提示", u"变速箱信息导入成功！")
                    self.mysql_connect()
                    self.Updatex()
                else:
                    tkMessageBox.showinfo("提示", u"请选择Excel表格！")
            else:
                tkMessageBox.showinfo("提示", u"请输入变速箱类型信息！")
        except MySQLdb.Error, e:
            tkMessageBox.showinfo("Mysql错误", u"%s" % (e.args[1]))

    # 车架信息导入
    def btn_carframeinformation(self):
        try:
            # 游标
            cur = conn.cursor()
            # 插入carframeinfo
            data_carframe = self.frm_right_carframe_namefrm_entry.get()  # 变速箱型号
            # 判断字符串非空
            if data_carframe:
                # 判断filename非空
                filename = tkFileDialog.askopenfilename(
                    filetypes=[("EXCEL file", "*.xlsx"), ("EXCEL file", "*.xls")])
                if filename:
                    # 插入carframeinfo
                    sql_carframeinfo = "INSERT INTO carframeinfo (CarframeName, DriveAxleSpeedRatio, Roll, MaxV, MaxF," \
                                       " WeightEmpty, WeightFull, AirArea, nDriveAxleSpeedRatio, Iwheel) VALUES (%s, %s,%s, %s, %s, %s,%s,%s,%s,%s)"
                    data = xlrd.open_workbook(filename)
                    table = data.sheets()[0]
                    tabledict = table.row_values(1)
                    tabledict.insert(0, data_carframe)
                    param02 = tuple(tabledict)
                    # 插入数据
                    cur.execute(sql_carframeinfo, param02)
                    conn.commit()
                    self.frm_status_label["text"] = "Mysql status：车架信息导入成功！"
                    tkMessageBox.showinfo("提示", u"车架信息导入成功！")
                    self.mysql_connect()
                    self.Updatex()
                else:
                    tkMessageBox.showinfo("提示", u"请选择Excel表格！")
            else:
                tkMessageBox.showinfo("提示", u"请输入车架类型信息！")
        except MySQLdb.Error, e:
            tkMessageBox.showinfo("Mysql错误", u"%s" % (e.args[1]))

# 车辆数据删除
class Loader_Delete(tk.Toplevel):
    # 初始化函数
    def __init__(self, master=None):
        tk.Toplevel.__init__(self)
        self.original_frame = master
        self.resizable(False, False)
        self.title("车辆信息删除")
        self.create_frame()
        self.mysql_connect()

    # 总体框架【上下】
    def create_frame(self):
        self.frm = pytk.PyLabelFrame(self)
        self.frm_status = pytk.PyLabelFrame(self)

        self.frm.grid(row=0, column=0, sticky="wesn")
        self.frm_status.grid(row=1, column=0, sticky="wesn")

        self.create_frm()
        self.create_frm_status()

    # 总体框架【左右】
    def create_frm(self):
        self.frm_left = pytk.PyLabelFrame(self.frm)
        self.frm_right = pytk.PyLabelFrame(self.frm)

        self.frm_left.grid(row=0, column=0, padx=5, pady=5, sticky="wesn")
        self.frm_right.grid(row=0, column=1, padx=5, pady=5, sticky="wesn")

        self.create_frm_left()
        self.create_frm_right()

    # 框架 选择
    def create_frm_left(self):
        self.frm_left_select_frm = pytk.PyLabelFrame(self.frm_left)
        self.frm_left_select_label = pytk.PyLabel(self.frm_left_select_frm,
                                                  text="车辆部件选取",
                                                  font=("Times", 25))
        self._radio_intvar = tk.IntVar()
        self.frm_left_select_rbtn_car = pytk.PyRadiobutton(self.frm_left, text="车辆型号",
                                                           variable=self._radio_intvar,
                                                           value=0, font=("Monaco", 15), command = self.rbtn_car)
        self.frm_left_select_rbtn_engine = pytk.PyRadiobutton(self.frm_left, text="发动机型号",
                                                              variable=self._radio_intvar,
                                                              value=1, font=("Monaco", 15), command = self.rbtn_engine)
        self.frm_left_select_rbtn_turbine = pytk.PyRadiobutton(self.frm_left, text="液力变矩器型号",
                                                               variable=self._radio_intvar,
                                                               value=2, font=("Monaco", 15), command = self.rbtn_turbine)
        self.frm_left_select_rbtn_gear = pytk.PyRadiobutton(self.frm_left, text="变速箱型号",
                                                            variable=self._radio_intvar,
                                                            value=3, font=("Monaco", 15), command = self.rbtn_gear)
        self.frm_left_select_rbtn_carframe = pytk.PyRadiobutton(self.frm_left, text="车架型号",
                                                                variable=self._radio_intvar,
                                                                value=4, font=("Monaco", 15), command = self.rbtn_carframe)
        self.frm_left_select_rbtn_enginecharacter = pytk.PyRadiobutton(self.frm_left, text="发动机特性曲线",
                                                                       variable=self._radio_intvar,
                                                                       value=5, font=("Monaco", 15), command = self.rbtn_enginecurve)
        self.frm_left_select_rbtn_turbinecharacter = pytk.PyRadiobutton(self.frm_left, text="液力变矩器特性曲线",
                                                                        variable=self._radio_intvar,
                                                                        value=6, font=("Monaco", 15), command = self.rbtn_turbinecurve)
        self.frm_left_select_rbtn_traction = pytk.PyRadiobutton(self.frm_left, text="牵引力特性曲线",
                                                                variable=self._radio_intvar,
                                                                value=7, font=("Monaco", 15), command = self.rbtn_turbinetraction)
        self.frm_left_select_frm.grid(row=0, column=0, sticky="wsne")
        self.frm_left_select_rbtn_car.grid(row=1, column=0, padx=0, pady=10, sticky="w")
        self.frm_left_select_rbtn_engine.grid(row=2, column=0, padx=0, pady=10, sticky="w")
        self.frm_left_select_rbtn_turbine.grid(row=3, column=0, padx=0, pady=10, sticky="w")
        self.frm_left_select_rbtn_gear.grid(row=4, column=0, padx=0, pady=10, sticky="w")
        self.frm_left_select_rbtn_carframe.grid(row=5, column=0, padx=0, pady=10, sticky="w")
        self.frm_left_select_label.grid(row=0, column=0, padx=50, pady=0, sticky="wsne")
        self.frm_left_select_rbtn_enginecharacter.grid(row=6, column=0, padx=0, pady=10, sticky="w")
        self.frm_left_select_rbtn_turbinecharacter.grid(row=7, column=0, padx=0, pady=10, sticky="w")
        self.frm_left_select_rbtn_traction.grid(row=8, column=0, padx=0, pady=10, sticky="w")

    # 框架 右
    def create_frm_right(self):
        self.frm_right_listboxname = pytk.PyLabelFrame(self.frm_right)
        self.frm_right_do = pytk.PyLabelFrame(self.frm_right)
        self.frm_left_back = pytk.PyLabelFrame(self.frm_right)

        self.frm_right_listboxname.grid(row=0, column=0, padx=20, pady=20, sticky="wesn")
        self.frm_right_do.grid(row=1, column=0, padx=20, pady=10, sticky="wesn")
        self.frm_left_back.grid(row=2, column=0, padx=20, pady=10, sticky="wesn")
        self.create_frm_right_listboxname()
        self.create_frm_right_do()

    # 列表
    def create_frm_right_listboxname(self):
        self.frm_right_listbox_name_label = pytk.PyLabel(self.frm_right_listboxname,
                                                         text="部件型号：",
                                                         font=("Times", 15))
        self.frm_right_listbox_name = pytk.PyListbox(self.frm_right_listboxname, width=25, height=17,
                                                     font=("Monaco", 15))
        self.frm_right_listbox_name_label.grid(row=0, column=0, padx=0, pady=0, sticky="w")
        self.frm_right_listbox_name.grid(row=1, column=0, padx=0, pady=0, sticky="wesn")

    # 操作
    def create_frm_right_do(self):
        self.frm_right_btn_delete = pytk.PyButton(self.frm_right_do,
                                                  text="删除此条",
                                                  font=g_font,
                                                  command=self.Btn_delete)
        self.frm_right_btn_delete.grid(row=0, column=0, padx=90, pady=15, sticky="wesn")
        self.frm_right_btn_back = pytk.PyButton(self.frm_right_do,
                                               text="返回主菜单",
                                               font=g_font,
                                               command=self.Back_main_menu)
        self.frm_right_btn_back.grid(row=1, column=0, padx=90, pady=15,  sticky="wesn")

    # 框架 状态栏
    def create_frm_status(self):
        self.frm_status_label = pytk.PyLabel(self.frm_status,
                                             text="Mysql status：无",
                                             font=g_font)
        self.frm_status_label.grid(row=0, column=0, padx=5, pady=5, sticky="wesn")

    # MYSQL连接
    def mysql_connect(self):
        try:
            # 选择数据库
            conn.select_db('loaderdb')
            self.frm_status_label["text"] = "Mysql status：已连接到数据库loaderdb"
        except MySQLdb.Error, e:
            tkMessageBox.showinfo("状态：", u"MySQL Error： %d:%s" % (e.args[0], e.args[1]))
            self.frm_status_label["text"] = u"MySQL Error： %d:%s" % (e.args[0], e.args[1])
            self.frm_status_label["text"] = u"Mysql status：数据库连接失败！"

    # MYSQL查询
    def mysql_inquiry(self, input_data):
        try:
            input_column = input_data[0]
            input_table = input_data[1]
            # 查询语句
            sql_inquery = "SELECT {0} FROM {1}".format(input_column, input_table)

            # 游标，执行，返回stus
            cur = conn.cursor()
            cur.execute(sql_inquery)
            stus = cur.fetchall()
            # 提交
            conn.commit()
            # 关闭游标
            cur.close()
            # 显示
            self.frm_right_listbox_name.delete("0","end")
            self.frm_status_label["text"] = "Mysql status：已连接到表" + input_table
            if stus:
                for i in range(len(stus)):
                    self.frm_right_listbox_name.insert("end", '型号：'+ stus[i][input_column])
        except MySQLdb.Error, e:
            tkMessageBox.showinfo("状态：", u"MySQL Error： %d:%s" % (e.args[0], e.args[1]))
            self.frm_status_label["text"] = u"MySQL Error： %d:%s" % (e.args[0], e.args[1])
            self.frm_status_label["text"] = u"Mysql status：表单连接失败！"

    # MYSQL查询
    def mysql_inquiry1(self, input_data):
        try:
            input_column = input_data[0]
            input_column1 = input_data[1]
            input_table = input_data[2]
            # 查询语句
            sql_inquery = "SELECT {0},{1} FROM {2}".format(input_column, input_column1, input_table)

            # 游标，执行，返回 stus
            cur = conn.cursor()
            cur.execute(sql_inquery)
            stus = cur.fetchall()
            # 提交
            conn.commit()
            # 关闭游标
            cur.close()
            # 显示
            self.frm_right_listbox_name.delete("0", "end")
            self.frm_status_label["text"] = "Mysql status：已连接到表" + input_table
            data_column = []
            if stus:
                for i in range(len(stus)):
                     column = stus[i][input_column]
                     column1 = stus[i][input_column1]
                     data_column.append('型号：'+ column + ' 实验组别：' + str(column1))
                data_column = sorted(set(data_column), key=data_column.index)
                for i in range(len(data_column)):
                    self.frm_right_listbox_name.insert("end", data_column[i])
        except MySQLdb.Error, e:
            tkMessageBox.showinfo("状态：", u"MySQL Error： %d:%s" % (e.args[0], e.args[1]))
            self.frm_status_label["text"] = u"MySQL Error： %d:%s" % (e.args[0], e.args[1])
            self.frm_status_label["text"] = u"Mysql status：表单连接失败！"

    # 删除
    def Btn_delete(self):
        indexs = self.frm_right_listbox_name.curselection()
        if indexs:
            indexs_data = indexs[0]
            string_data = self.frm_right_listbox_name.get(indexs_data)
            num = self._radio_intvar.get()
            # 车辆
            if num == 0:
                if string_data:
                    stringxx = string_data
                    stringxx = string.replace(stringxx, '型号：', '')
                sql_delete = "DELETE FROM carinfo WHERE CarName = '{0}'".format(stringxx)
            # 发动机
            elif num == 1:
                if string_data:
                    stringxx = string_data
                    stringxx = string.replace(stringxx, '型号：', '')
                sql_delete = "DELETE FROM engineinfo WHERE EngineName = '{0}'".format(stringxx)
            # 液力变矩器
            elif num == 2:
                if string_data:
                    stringxx = string_data
                    stringxx = string.replace(stringxx, '型号：', '')
                sql_delete = "DELETE FROM turbineinfo WHERE TurbineName = '{0}'".format(stringxx)
            # 变速箱
            elif num == 3:
                if string_data:
                    stringxx = string_data
                    stringxx = string.replace(stringxx, '型号：', '')
                sql_delete = "DELETE FROM gearinfo WHERE GearName = '{0}'".format(stringxx)
            # 车架
            elif num == 4:
                if string_data:
                    stringxx = string_data
                    stringxx = string.replace(stringxx, '型号：', '')
                sql_delete = "DELETE FROM carframeinfo WHERE CarframeName = '{0}'".format(stringxx)
            # 发动机特性曲线
            elif num == 5:
                if string_data:
                    stringxx = string_data
                    stringxx = string.replace(stringxx, '型号：', '')
                    stringxx = string.replace(stringxx, ' 实验组别：',',')
                    stringxx = string.split(stringxx, ',')
                    namex = stringxx[0]
                    groupx = stringxx[1]
                sql_delete = "DELETE FROM enginecurve WHERE EngineName = '{0}' AND EngineGroupx = '{1}'".format(namex,
                                                                                                                groupx)
            # 液力变矩器特性曲线
            elif num == 6:
                if string_data:
                    stringxx = string_data
                    stringxx = string.replace(stringxx, '型号：', '')
                    stringxx = string.replace(stringxx, ' 实验组别：', ',')
                    stringxx = string.split(stringxx, ',')
                    namex = stringxx[0]
                    groupx = stringxx[1]
                sql_delete = "DELETE FROM turbinecurve WHERE TurbineName = '{0}' AND TurbineGroupx = '{1}'".format(namex,
                                                                                                                groupx)
            # 牵引力特性曲线
            elif num == 7:
                if string_data:
                    stringxx = string_data
                    stringxx = string.replace(stringxx, '型号：', '')
                    stringxx = string.replace(stringxx, ' 实验组别：', ',')
                    stringxx = string.split(stringxx, ',')
                    namex = stringxx[0]
                    groupx = stringxx[1]
                sql_delete = "DELETE FROM tractionefficiency WHERE TurbineName = '{0}' AND TractionGroupx = {1}".format(namex,
                                                                                                                groupx)
            try:
                cur = conn.cursor()
                cur.execute(sql_delete)
                conn.commit()
                if num == 0:
                    self.rbtn_car()
                elif num == 1:
                    self.rbtn_engine()
                elif num == 2:
                    self.rbtn_turbine()
                elif num == 3:
                    self.rbtn_gear()
                elif num == 4:
                    self.rbtn_carframe()
                elif num == 5:
                    self.rbtn_enginecurve()
                elif num == 6:
                    self.rbtn_turbinecurve()
                elif num == 7:
                    self.rbtn_turbinetraction()
            except MySQLdb.Error, e:
                  tkMessageBox.showinfo("状态：", u"MySQL Error： %d:%s" % (e.args[0], e.args[1]))
                  self.frm_status_label["text"] = u"MySQL Error： %d:%s" % (e.args[0], e.args[1])
        else:
            tkMessageBox.showinfo("状态：", "请选择数据索引")

    # 返回主菜单
    def Back_main_menu(self):
        self.withdraw()
        MainWindow(self)

    # 车
    def rbtn_car(self):
        input_data = ['CarName', 'carinfo']
        self.mysql_inquiry(input_data)

    # 发动机
    def rbtn_engine(self):
        input_data = ['EngineName', 'engineinfo']
        self.mysql_inquiry(input_data)

    # 液力变矩器
    def rbtn_turbine(self):
        input_data = ['TurbineName', 'turbineinfo']
        self.mysql_inquiry(input_data)

    # 变速箱
    def rbtn_gear(self):
        input_data = ['GearName', 'gearinfo']
        self.mysql_inquiry(input_data)

    # 车架
    def rbtn_carframe(self):
        input_data = ['CarframeName', 'carframeinfo']
        self.mysql_inquiry(input_data)

    # 发动机特性曲线
    def rbtn_enginecurve(self):
        input_data = ['EngineName', 'EngineGroupx', 'enginecurve']
        self.mysql_inquiry1(input_data)

    # 液力变矩器特性曲线
    def rbtn_turbinecurve(self):
        input_data = ['TurbineName', 'TurbineGroupx', 'turbinecurve']
        self.mysql_inquiry1(input_data)

    # 牵引力特性曲线
    def rbtn_turbinetraction(self):
        input_data = ['TurbineName', 'TractionGroupx', 'tractionefficiency']
        self.mysql_inquiry1(input_data)

# 车辆数据显示
class Loader_Show(tk.Toplevel):
    # 初始化函数
    def __init__(self, master=None):
        tk.Toplevel.__init__(self)
        self.original_frame = master
        self.resizable(False, False)
        self.title("车辆信息管理")
        self.mysql_connect()
        self.create_frame()

    # 总体框架【上下】
    def create_frame(self):
        self.frm = pytk.PyLabelFrame(self)
        self.frm_status = pytk.PyLabelFrame(self)

        self.frm.grid(row=0, column=0, sticky="wesn")
        self.frm_status.grid(row=1, column=0, sticky="wesn")

        self.create_frm()
        self.create_frm_status()

    # 总体框架【左右】
    def create_frm(self):
        self.frm_left = pytk.PyLabelFrame(self.frm)
        self.frm_right = pytk.PyLabelFrame(self.frm)

        self.frm_left.grid(row=0, column=0, padx=5, pady=5, sticky="wesn")
        self.frm_right.grid(row=0, column=1, padx=5, pady=5, sticky="wesn")

        self.create_frm_left()
        self.create_frm_right()

    # 框架 左
    def create_frm_left(self):
        # 选择
        self.frm_left_select = pytk.PyLabelFrame(self.frm_left)
        self.frm_select_label = pytk.PyLabel(self.frm_left_select, width=17,   text="车辆型号", font=("Times", 15))
        self._var1 = tk.StringVar()
        self.frm_left_car_optionmenu = tk.OptionMenu(self.frm_left_select, self._var1,
                                                                *self._listcar)
        self.frm_left_car_optionmenu.config(font=('Times', 15), bg="#292929", fg="#E0EEEE", width=15)
        self.frm_left_car_optionmenu.bind('<Button-1>', self.Opt_car)

        self.frm_left_select.grid(row=0, column=0, padx=20, pady=20, sticky="w")
        self.frm_select_label.grid(row=0, column=0, sticky="w")
        self.frm_left_car_optionmenu.grid(row=1, column=0, sticky="wsne")

        # 车架
        self.frm_left_carframe = pytk.PyLabelFrame(self.frm_left)
        self.frm_left_carframe_name = pytk.PyLabelFrame(self.frm_left_carframe)
        self.frm_left_carframe_speedratio = pytk.PyLabelFrame(self.frm_left_carframe)
        self.frm_left_carframe_roll = pytk.PyLabelFrame(self.frm_left_carframe)
        self.frm_left_carframe_maxv = pytk.PyLabelFrame(self.frm_left_carframe)
        self.frm_left_carframe_maxf = pytk.PyLabelFrame(self.frm_left_carframe)
        self.frm_left_carframe_weightempty = pytk.PyLabelFrame(self.frm_left_carframe)
        self.frm_left_carframe_weightfull = pytk.PyLabelFrame(self.frm_left_carframe)

        self.frm_left_carframe.grid(row=1, column=0, padx=20, pady=20, sticky="wsne")
        self.frm_left_carframe_name.grid(row=1, column=0, padx=0, pady=0, sticky="wsne")
        self.frm_left_carframe_speedratio.grid(row=2, column=0,  padx=0, pady=0,sticky="wsne")
        self.frm_left_carframe_roll.grid(row=3, column=0, padx=0, pady=0, sticky="wsne")
        self.frm_left_carframe_maxv.grid(row=4, column=0, padx=0, pady=0, sticky="wsne")
        self.frm_left_carframe_maxf.grid(row=5, column=0, padx=0, pady=0, sticky="wsne")
        self.frm_left_carframe_weightempty.grid(row=6, column=0,  padx=0, pady=0,sticky="wsne")
        self.frm_left_carframe_weightfull.grid(row=7, column=0, padx=0, pady=0, sticky="wsne")


        self.frm_left_carframe_name_label = pytk.PyLabel(self.frm_left_carframe_name, text="车架型号：",
                                                     width=17, font=("Times", 15))
        self.frm_left_carframe_name_data = pytk.PyLabel(self.frm_left_carframe_name, text="",
                                                        width=17, font=("Times", 15))
        self.frm_left_carframe_name_label.grid(row=0, column=0, padx=0, pady=0,sticky="w")
        self.frm_left_carframe_name_data.grid(row=1, column=0,padx=0, pady=0, sticky="w")

        self.frm_left_carframe_speedratio_label = pytk.PyLabel(self.frm_left_carframe_speedratio, text="驱动桥速比：",
                                                      font=("Times", 15), width=17)
        self.frm_left_carframe_speedratio_data = pytk.PyLabel(self.frm_left_carframe_speedratio, text="",
                                                      font=("Times", 15), width=17)
        self.frm_left_carframe_speedratio_label.grid(row=0, column=0,  padx=0, pady=0,sticky="w")
        self.frm_left_carframe_speedratio_data.grid(row=1, column=0, padx=0, pady=0, sticky="w")

        self.frm_left_carframe_roll_label = pytk.PyLabel(self.frm_left_carframe_roll, text="车轮直径(m)：",
                                                      font=("Times", 15), width=17)
        self.frm_left_carframe_roll_data = pytk.PyLabel(self.frm_left_carframe_roll, text="",
                                                      font=("Times", 15), width=17)
        self.frm_left_carframe_roll_label.grid(row=0, column=0, padx=0, pady=0, sticky="w")
        self.frm_left_carframe_roll_data.grid(row=1, column=0,  padx=0, pady=0,sticky="w")

        self.frm_left_carframe_maxv_label = pytk.PyLabel(self.frm_left_carframe_maxv, text="最高车速(m/s)：",
                                                      font=("Times", 15), width=17)
        self.frm_left_carframe_maxv_data = pytk.PyLabel(self.frm_left_carframe_maxv, text="",
                                                      font=("Times", 15), width=17)
        self.frm_left_carframe_maxv_label.grid(row=0, column=0,  padx=0, pady=0,sticky="w")
        self.frm_left_carframe_maxv_data.grid(row=1, column=0, padx=0, pady=0, sticky="w")

        self.frm_left_carframe_maxf_label = pytk.PyLabel(self.frm_left_carframe_maxf, text="最大牵引力(kN)：",
                                                      font=("Times", 15), width=17)
        self.frm_left_carframe_maxf_data = pytk.PyLabel(self.frm_left_carframe_maxf, text="",
                                                      font=("Times", 15), width=17)
        self.frm_left_carframe_maxf_label.grid(row=0, column=0, padx=0, pady=0, sticky="w")
        self.frm_left_carframe_maxf_data.grid(row=1, column=0, padx=0, pady=0, sticky="w")

        self.frm_left_carframe_weightempty_label = pytk.PyLabel(self.frm_left_carframe_weightempty, text="空载重量(T)：",
                                                     font=("Times", 15), width=17)
        self.frm_left_carframe_weightempty_data = pytk.PyLabel(self.frm_left_carframe_weightempty, text="",
                                                                font=("Times", 15), width=17)
        self.frm_left_carframe_weightempty_label.grid(row=0, column=0, padx=0, pady=0, sticky="w")
        self.frm_left_carframe_weightempty_data.grid(row=1, column=0, padx=0, pady=0, sticky="w")

        self.frm_left_carframe_weightfull_label = pytk.PyLabel(self.frm_left_carframe_weightfull, text="满载重量(T)：",
                                                      font=("Times", 15), width=17)
        self.frm_left_carframe_weightfull_data = pytk.PyLabel(self.frm_left_carframe_weightfull, text="",
                                                      font=("Times", 15), width=17)
        self.frm_left_carframe_weightfull_label.grid(row=0, column=0, padx=0, pady=0, sticky="w")
        self.frm_left_carframe_weightfull_data.grid(row=1, column=0, padx=0, pady=0, sticky="w")

        self.frm_left_quit = pytk.PyLabelFrame(self.frm_left)
        self.frm_left_quit.grid(row=2, column=0, padx=20, pady=80, sticky="w")
        self.frm_left_quit_btn = pytk.PyButton(self.frm_left_quit,
                                               text="返回主菜单",
                                               height=2,
                                               font=g_font,
                                               command=self.Back_main_menu)
        self.frm_left_quit_btn.grid(row=1, column=0, padx=50, sticky="wesn")

    # 框架 右
    def create_frm_right(self):
        self.frm_right_carpic = pytk.PyLabelFrame(self.frm_right)
        self.frm_right_data = pytk.PyLabelFrame(self.frm_right)

        self.frm_right_engine = pytk.PyLabelFrame(self.frm_right_data)
        self.frm_right_turbine = pytk.PyLabelFrame(self.frm_right_data)
        self.frm_right_gear = pytk.PyLabelFrame(self.frm_right_data)

        self.frm_right_carpic.grid(row=0, column=0, padx=20, pady=0, sticky="wesn")
        self.frm_right_data.grid(row=1, column=0, padx=20, pady=0, sticky="wesn")

        self.frm_right_engine.grid(row=0, column=0, padx=20, pady=0, sticky="wesn")
        self.frm_right_turbine.grid(row=0, column=1, padx=20, pady=0, sticky="wesn")
        self.frm_right_gear.grid(row=0, column=2, padx=20, pady=0, sticky="wesn")

        self.create_frm_right_carpic()
        self.create_frm_right_engine()
        self.create_frm_right_turbine()
        self.create_frm_right_gear()

    # 车图
    def create_frm_right_carpic(self):
        # 车架
        self.frm_right_carpic_name = pytk.PyLabelFrame(self.frm_right_carpic)
        self.frm_right_carpic_pic = pytk.PyLabelFrame(self.frm_right_carpic)


        self.frm_right_carpic_name.grid(row=0, column=0, padx=0, pady=0, sticky="wsne")
        self.frm_right_carpic_pic.grid(row=1, column=0, padx=0, pady=0, sticky="wsne")

        self.frm_right_carpic_name_label = pytk.PyLabel(self.frm_right_carpic_name, text="装载机图片：",
                                                        width=17, font=("Times", 15))
        self.frm_right_carpic_name_label.grid(row=0, column=0, padx=0, pady=0, sticky="w")

        # 以一个PIL图像对象打开
        pil_image = Image.open('pic//null.jpg')
        # 缩放图像让它保持比例，同时限制在一个矩形框范围内
        pil_image_resized = pil_image.resize((400, 300), Image.ANTIALIAS)
        self._tk_image = ImageTk.PhotoImage(pil_image_resized)
        self.frm_right_carpic_pic_pic = pytk.PyLabel(self.frm_right_carpic_pic, image=self._tk_image)
        self.frm_right_carpic_pic_pic.grid(row=0, column=0, pady=0, padx=0, sticky="wesn")

        # 以一个PIL图像对象打开
        pil_image1 = Image.open('pic//null.jpg')
        # 缩放图像让它保持比例，同时限制在一个矩形框范围内
        pil_image_resized1 = pil_image1.resize((400, 300), Image.ANTIALIAS)
        self._tk_image1 = ImageTk.PhotoImage(pil_image_resized1)
        self.frm_right_carpic_pic_pic1 = pytk.PyLabel(self.frm_right_carpic_pic, image=self._tk_image1)
        self.frm_right_carpic_pic_pic1.grid(row=0, column=1, pady=0, padx=0, sticky="wesn")

        self.frm_right_carpic_rbtn = pytk.PyLabelFrame(self.frm_right_carpic_pic)
        self.frm_right_carpic_rbtn.grid(row=0, column=2, padx=0, pady=0, sticky="wsne")

        self._radio_intvar = tk.IntVar()
        self.frm_right_carpic_rbtn_chicun = pytk.PyRadiobutton(self.frm_right_carpic_rbtn, text="尺寸参数",
                                                           variable=self._radio_intvar,
                                                           value=0, font=("Monaco", 15), command = self.rbtn_chicun)
        self.frm_right_carpic_rbtn_bujian = pytk.PyRadiobutton(self.frm_right_carpic_rbtn, text="部件参数",
                                                           variable=self._radio_intvar,
                                                           value=1, font=("Monaco", 15), command = self.rbtn_bujian)
        self.frm_right_carpic_rbtn_bujian.grid(row=0, column=0, padx=0, pady=20, sticky="wsne")
        self.frm_right_carpic_rbtn_chicun.grid(row=1, column=0, padx=0, pady=20, sticky="wsne")

    # 发动机
    def create_frm_right_engine(self):
        self.frm_right_engine_name = pytk.PyLabelFrame(self.frm_right_engine)
        self.frm_right_engine_ratedpower = pytk.PyLabelFrame(self.frm_right_engine)
        self.frm_right_engine_ratedspeed = pytk.PyLabelFrame(self.frm_right_engine)
        self.frm_right_engine_maxtorquespeed = pytk.PyLabelFrame(self.frm_right_engine)
        self.frm_right_engine_maxtorque = pytk.PyLabelFrame(self.frm_right_engine)
        self.frm_right_engine_numcylinder = pytk.PyLabelFrame(self.frm_right_engine)
        self.frm_right_engine_dcylinder = pytk.PyLabelFrame(self.frm_right_engine)
        self.frm_right_engine_pistonstroke = pytk.PyLabelFrame(self.frm_right_engine)
        self.frm_right_engine_pistondisplacement = pytk.PyLabelFrame(self.frm_right_engine)
        self.frm_right_engine_compressionratio = pytk.PyLabelFrame(self.frm_right_engine)
        self.frm_right_engine_lengthx = pytk.PyLabelFrame(self.frm_right_engine)
        self.frm_right_engine_width = pytk.PyLabelFrame(self.frm_right_engine)
        self.frm_right_engine_height = pytk.PyLabelFrame(self.frm_right_engine)
        self.frm_right_engine_weight = pytk.PyLabelFrame(self.frm_right_engine)
        self.frm_right_engine_enginebtn = pytk.PyLabelFrame(self.frm_right_engine)


        self.frm_right_engine_name.grid(row=0, column=0, padx=0, pady=0, sticky="wsne")
        self.frm_right_engine_ratedpower.grid(row=1, column=0, padx=0, pady=0, sticky="wsne")
        self.frm_right_engine_ratedspeed.grid(row=2, column=0, padx=0, pady=0, sticky="wsne")
        self.frm_right_engine_maxtorquespeed.grid(row=3, column=0, padx=0, pady=0, sticky="wsne")
        self.frm_right_engine_maxtorque.grid(row=4, column=0, padx=0, pady=0, sticky="wsne")
        self.frm_right_engine_numcylinder.grid(row=5, column=0, padx=0, pady=0, sticky="wsne")
        self.frm_right_engine_dcylinder.grid(row=6, column=0, padx=0, pady=0, sticky="wsne")
        self.frm_right_engine_pistonstroke.grid(row=0, column=1, padx=0, pady=0, sticky="wsne")
        self.frm_right_engine_pistondisplacement.grid(row=1, column=1, padx=0, pady=0, sticky="wsne")
        self.frm_right_engine_compressionratio.grid(row=2, column=1, padx=0, pady=0, sticky="wsne")
        self.frm_right_engine_lengthx.grid(row=3, column=1, padx=0, pady=0, sticky="wsne")
        self.frm_right_engine_width.grid(row=4, column=1, padx=0, pady=0, sticky="wsne")
        self.frm_right_engine_height.grid(row=5, column=1, padx=0, pady=0, sticky="wsne")
        self.frm_right_engine_weight.grid(row=6, column=1, padx=0, pady=0, sticky="wsne")
        self.frm_right_engine_enginebtn.grid(row=7, column=0, padx=0, pady=0, sticky="wsne")


        self.frm_right_engine_name_label = pytk.PyLabel(self.frm_right_engine_name, text="发动机型号：",
                                                         width=17, font=("Times", 15))
        self.frm_right_engine_name_data = pytk.PyLabel(self.frm_right_engine_name, text="",
                                                        width=17, font=("Times", 15))
        self.frm_right_engine_name_label.grid(row=0, column=0, padx=0, pady=0, sticky="w")
        self.frm_right_engine_name_data.grid(row=1, column=0, padx=0, pady=0, sticky="w")

        self.frm_right_engine_ratedpower_label = pytk.PyLabel(self.frm_right_engine_ratedpower, text="额定功率(kWh)：",
                                                    width=17, font=("Times", 15))
        self.frm_right_engine_ratedpower_data = pytk.PyLabel(self.frm_right_engine_ratedpower, text="",
                                                   width=17, font=("Times", 15))
        self.frm_right_engine_ratedpower_label.grid(row=0, column=0, padx=0, pady=0, sticky="w")
        self.frm_right_engine_ratedpower_data.grid(row=1, column=0, padx=0, pady=0, sticky="w")

        self.frm_right_engine_ratedspeed_label = pytk.PyLabel(self.frm_right_engine_ratedspeed, text="额定转速(rpm)：",
                                                              width=17, font=("Times", 15))
        self.frm_right_engine_ratedspeed_data = pytk.PyLabel(self.frm_right_engine_ratedspeed, text="",
                                                             width=17, font=("Times", 15))
        self.frm_right_engine_ratedspeed_label.grid(row=0, column=0, padx=0, pady=0, sticky="w")
        self.frm_right_engine_ratedspeed_data.grid(row=1, column=0, padx=0, pady=0, sticky="w")

        self.frm_right_engine_maxtorquespeed_label = pytk.PyLabel(self.frm_right_engine_maxtorquespeed, text="最大扭矩转速(rpm)：",
                                                              width=17, font=("Times", 15))
        self.frm_right_engine_maxtorquespeed_data = pytk.PyLabel(self.frm_right_engine_maxtorquespeed, text="",
                                                             width=17, font=("Times", 15))
        self.frm_right_engine_maxtorquespeed_label.grid(row=0, column=0, padx=0, pady=0, sticky="w")
        self.frm_right_engine_maxtorquespeed_data.grid(row=1, column=0, padx=0, pady=0, sticky="w")

        self.frm_right_engine_maxtorque_label = pytk.PyLabel(self.frm_right_engine_maxtorque, text="最大扭矩(N*m)：",
                                                        width=17, font=("Times", 15))
        self.frm_right_engine_maxtorque_data = pytk.PyLabel(self.frm_right_engine_maxtorque, text="",
                                                       width=17, font=("Times", 15))
        self.frm_right_engine_maxtorque_label.grid(row=0, column=0, padx=0, pady=0, sticky="w")
        self.frm_right_engine_maxtorque_data.grid(row=1, column=0, padx=0, pady=0, sticky="w")

        self.frm_right_engine_numcylinder_label = pytk.PyLabel(self.frm_right_engine_numcylinder, text="气缸数：",
                                                              width=17, font=("Times", 15))
        self.frm_right_engine_numcylinder_data = pytk.PyLabel(self.frm_right_engine_numcylinder, text="",
                                                             width=17, font=("Times", 15))
        self.frm_right_engine_numcylinder_label.grid(row=0, column=0, padx=0, pady=0, sticky="w")
        self.frm_right_engine_numcylinder_data.grid(row=1, column=0, padx=0, pady=0, sticky="w")

        self.frm_right_engine_dcylinder_label = pytk.PyLabel(self.frm_right_engine_dcylinder, text="气缸直径(cm)：",
                                                              width=17, font=("Times", 15))
        self.frm_right_engine_dcylinder_data = pytk.PyLabel(self.frm_right_engine_dcylinder, text="",
                                                             width=17, font=("Times", 15))
        self.frm_right_engine_dcylinder_label.grid(row=0, column=0, padx=0, pady=0, sticky="w")
        self.frm_right_engine_dcylinder_data.grid(row=1, column=0, padx=0, pady=0, sticky="w")

        self.frm_right_engine_pistonstroke_label = pytk.PyLabel(self.frm_right_engine_pistonstroke,
                                                                  text="活塞冲程(cm)：",
                                                                  width=17, font=("Times", 15))
        self.frm_right_engine_pistonstroke_data = pytk.PyLabel(self.frm_right_engine_pistonstroke, text="",
                                                                 width=17, font=("Times", 15))
        self.frm_right_engine_pistonstroke_label.grid(row=0, column=0, padx=0, pady=0, sticky="w")
        self.frm_right_engine_pistonstroke_data.grid(row=1, column=0, padx=0, pady=0, sticky="w")

        self.frm_right_engine_pistondisplacement_label = pytk.PyLabel(self.frm_right_engine_pistondisplacement,
                                                                  text="活塞总排量(L)：",
                                                                  width=17, font=("Times", 15))
        self.frm_right_engine_pistondisplacement_data = pytk.PyLabel(self.frm_right_engine_pistondisplacement, text="",
                                                                 width=17, font=("Times", 15))
        self.frm_right_engine_pistondisplacement_label.grid(row=0, column=0, padx=0, pady=0, sticky="w")
        self.frm_right_engine_pistondisplacement_data.grid(row=1, column=0, padx=0, pady=0, sticky="w")

        self.frm_right_engine_compressionratio_label = pytk.PyLabel(self.frm_right_engine_compressionratio,
                                                                  text="压缩比：",
                                                                  width=17, font=("Times", 15))
        self.frm_right_engine_compressionratio_data = pytk.PyLabel(self.frm_right_engine_compressionratio, text="",
                                                                 width=17, font=("Times", 15))
        self.frm_right_engine_compressionratio_label.grid(row=0, column=0, padx=0, pady=0, sticky="w")
        self.frm_right_engine_compressionratio_data.grid(row=1, column=0, padx=0, pady=0, sticky="w")

        self.frm_right_engine_lengthx_label = pytk.PyLabel(self.frm_right_engine_lengthx,
                                                                  text="长度(cm)：",
                                                                  width=17, font=("Times", 15))
        self.frm_right_engine_lengthx_data = pytk.PyLabel(self.frm_right_engine_lengthx, text="",
                                                                 width=17, font=("Times", 15))
        self.frm_right_engine_lengthx_label.grid(row=0, column=0, padx=0, pady=0, sticky="w")
        self.frm_right_engine_lengthx_data.grid(row=1, column=0, padx=0, pady=0, sticky="w")

        self.frm_right_engine_width_label = pytk.PyLabel(self.frm_right_engine_width,
                                                                  text="宽度(cm)：",
                                                                  width=17, font=("Times", 15))
        self.frm_right_engine_width_data = pytk.PyLabel(self.frm_right_engine_width, text="",
                                                                 width=17, font=("Times", 15))
        self.frm_right_engine_width_label.grid(row=0, column=0, padx=0, pady=0, sticky="w")
        self.frm_right_engine_width_data.grid(row=1, column=0, padx=0, pady=0, sticky="w")

        self.frm_right_engine_height_label = pytk.PyLabel(self.frm_right_engine_height,
                                                                  text="高度(cm)：",
                                                                  width=17, font=("Times", 15))
        self.frm_right_engine_height_data = pytk.PyLabel(self.frm_right_engine_height, text="",
                                                                 width=17, font=("Times", 15))
        self.frm_right_engine_height_label.grid(row=0, column=0, padx=0, pady=0, sticky="w")
        self.frm_right_engine_height_data.grid(row=1, column=0, padx=0, pady=0, sticky="w")

        self.frm_right_engine_weight_label = pytk.PyLabel(self.frm_right_engine_weight,
                                                                  text="重量(kg)：",
                                                                  width=17, font=("Times", 15))
        self.frm_right_engine_weight_data = pytk.PyLabel(self.frm_right_engine_weight, text="",
                                                                 width=17, font=("Times", 15))
        self.frm_right_engine_weight_label.grid(row=0, column=0, padx=0, pady=0, sticky="w")
        self.frm_right_engine_weight_data.grid(row=1, column=0, padx=0, pady=0, sticky="w")

        self.frm_right_engine_enginebtn_btn = pytk.PyButton(self.frm_right_engine_enginebtn,
                                               text="发动机特性曲线",
                                               height=2,
                                               font=g_font,
                                               command=self.Btn_enginecurve)
        self.frm_right_engine_enginebtn_btn.grid(row=3, column=0, padx=33, sticky="wesn")

    # 液力变矩器
    def create_frm_right_turbine(self):
        self.frm_right_turbine_name = pytk.PyLabelFrame(self.frm_right_turbine)
        self.frm_right_turbine_d = pytk.PyLabelFrame(self.frm_right_turbine)
        self.frm_right_turbine_ratedspeed = pytk.PyLabelFrame(self.frm_right_turbine)
        self.frm_right_turbine_maxtorque = pytk.PyLabelFrame(self.frm_right_turbine)
        self.frm_right_turbine_ratedpower = pytk.PyLabelFrame(self.frm_right_turbine)
        self.frm_right_turbine_turbinecurve = pytk.PyLabelFrame(self.frm_right_turbine)
        self.frm_right_turbine_traction = pytk.PyLabelFrame(self.frm_right_turbine)

        self.frm_right_turbine_name.grid(row=0, column=0, padx=0, pady=0, sticky="wsne")
        self.frm_right_turbine_d.grid(row=1, column=0, padx=0, pady=0, sticky="wsne")
        self.frm_right_turbine_ratedspeed.grid(row=2, column=0, padx=0, pady=0, sticky="wsne")
        self.frm_right_turbine_maxtorque.grid(row=3, column=0, padx=0, pady=0, sticky="wsne")
        self.frm_right_turbine_ratedpower.grid(row=4, column=0, padx=0, pady=0, sticky="wsne")
        self.frm_right_turbine_turbinecurve.grid(row=5, column=0, padx=0, pady=0, sticky="wsne")
        self.frm_right_turbine_traction.grid(row=6, column=0, padx=0, pady=0, sticky="wsne")

        self.frm_right_turbine_name_label = pytk.PyLabel(self.frm_right_turbine_name, text="液力变矩器型号：",
                                                        width=17, font=("Times", 15))
        self.frm_right_turbine_name_data = pytk.PyLabel(self.frm_right_turbine_name, text="",
                                                             width=17, font=("Times", 15))
        self.frm_right_turbine_name_label.grid(row=0, column=0, padx=0, pady=0, sticky="w")
        self.frm_right_turbine_name_data.grid(row=1, column=0, padx=0, pady=0, sticky="w")

        self.frm_right_turbine_d_label = pytk.PyLabel(self.frm_right_turbine_d, text="有效循环圆直径(cm)：",
                                                              width=17, font=("Times", 15))
        self.frm_right_turbine_d_data = pytk.PyLabel(self.frm_right_turbine_d, text="",
                                                             width=17, font=("Times", 15))
        self.frm_right_turbine_d_label.grid(row=0, column=0, padx=0, pady=0, sticky="w")
        self.frm_right_turbine_d_data.grid(row=1, column=0, padx=0, pady=0, sticky="w")

        self.frm_right_turbine_ratedspeed_label = pytk.PyLabel(self.frm_right_turbine_ratedspeed, text="额定转速(rpm)：",
                                                              width=17, font=("Times", 15))
        self.frm_right_turbine_ratedspeed_data = pytk.PyLabel(self.frm_right_turbine_ratedspeed, text="",
                                                             width=17, font=("Times", 15))
        self.frm_right_turbine_ratedspeed_label.grid(row=0, column=0, padx=0, pady=0, sticky="w")
        self.frm_right_turbine_ratedspeed_data.grid(row=1, column=0, padx=0, pady=0, sticky="w")

        self.frm_right_turbine_maxtorque_label = pytk.PyLabel(self.frm_right_turbine_maxtorque,
                                                                  text="最大扭矩(N*m)：",
                                                                  width=17, font=("Times", 15))
        self.frm_right_turbine_maxtorque_data = pytk.PyLabel(self.frm_right_turbine_maxtorque, text="",
                                                                 width=17, font=("Times", 15))
        self.frm_right_turbine_maxtorque_label.grid(row=0, column=0, padx=0, pady=0, sticky="w")
        self.frm_right_turbine_maxtorque_data.grid(row=1, column=0, padx=0, pady=0, sticky="w")

        self.frm_right_turbine_ratedpower_label = pytk.PyLabel(self.frm_right_turbine_ratedpower, text="额定功率(kwh)：",
                                                             width=17, font=("Times", 15))
        self.frm_right_turbine_ratedpower_data = pytk.PyLabel(self.frm_right_turbine_ratedpower, text="",
                                                            width=17, font=("Times", 15))
        self.frm_right_turbine_ratedpower_label.grid(row=0, column=0, padx=0, pady=0, sticky="w")
        self.frm_right_turbine_ratedpower_data.grid(row=1, column=0, padx=0, pady=0, sticky="w")

        self.frm_right_turbine_turbinecurve_btn = pytk.PyButton(self.frm_right_turbine_turbinecurve,
                                               text="液力变矩器曲线",
                                               height=2,
                                               font=g_font,
                                               command=self.Btn_turbinecurve)
        self.frm_right_turbine_turbinecurve_btn.grid(row=1, column=0, padx=33, sticky="wesn")

        self.frm_right_turbine_traction_btn = pytk.PyButton(self.frm_right_turbine_traction,
                                               text="牵引力特性曲线",
                                               height=2,
                                               font=g_font,
                                               command=self.Btn_traction)
        self.frm_right_turbine_traction_btn.grid(row=1, column=0, padx=33, sticky="wesn")

    # 变速箱
    def create_frm_right_gear(self):
        self.frm_right_gear_name = pytk.PyLabelFrame(self.frm_right_gear)
        self.frm_right_gear_f1 = pytk.PyLabelFrame(self.frm_right_gear)
        self.frm_right_gear_f2 = pytk.PyLabelFrame(self.frm_right_gear)
        self.frm_right_gear_f3 = pytk.PyLabelFrame(self.frm_right_gear)
        self.frm_right_gear_f4 = pytk.PyLabelFrame(self.frm_right_gear)
        self.frm_right_gear_r1 = pytk.PyLabelFrame(self.frm_right_gear)
        self.frm_right_gear_r2 = pytk.PyLabelFrame(self.frm_right_gear)
        self.frm_right_gear_r3 = pytk.PyLabelFrame(self.frm_right_gear)

        self.frm_right_gear_name.grid(row=0, column=0, padx=0, pady=0, sticky="wsne")
        self.frm_right_gear_f1.grid(row=1, column=0, padx=0, pady=0, sticky="wsne")
        self.frm_right_gear_f2.grid(row=2, column=0, padx=0, pady=0, sticky="wsne")
        self.frm_right_gear_f3.grid(row=3, column=0, padx=0, pady=0, sticky="wsne")
        self.frm_right_gear_f4.grid(row=4, column=0, padx=0, pady=0, sticky="wsne")
        self.frm_right_gear_r1.grid(row=5, column=0, padx=0, pady=0, sticky="wsne")
        self.frm_right_gear_r2.grid(row=6, column=0, padx=0, pady=0, sticky="wsne")
        self.frm_right_gear_r3.grid(row=7, column=0, padx=0, pady=0, sticky="wsne")

        self.frm_right_gear_name_label = pytk.PyLabel(self.frm_right_gear_name, text="变速箱型号：",
                                                         width=17, font=("Times", 15))
        self.frm_right_gear_name_data = pytk.PyLabel(self.frm_right_gear_name, text="",
                                                        width=17, font=("Times", 15))
        self.frm_right_gear_name_label.grid(row=0, column=0, padx=0, pady=0, sticky="w")
        self.frm_right_gear_name_data.grid(row=1, column=0, padx=0, pady=0, sticky="w")

        self.frm_right_gear_f1_label = pytk.PyLabel(self.frm_right_gear_f1, text="F1变速比：",
                                                         width=17, font=("Times", 15))
        self.frm_right_gear_f1_data = pytk.PyLabel(self.frm_right_gear_f1, text="",
                                                        width=17, font=("Times", 15))
        self.frm_right_gear_f1_label.grid(row=0, column=0, padx=0, pady=0, sticky="w")
        self.frm_right_gear_f1_data.grid(row=1, column=0, padx=0, pady=0, sticky="w")

        self.frm_right_gear_f2_label = pytk.PyLabel(self.frm_right_gear_f2, text="F2变速比：",
                                                         width=17, font=("Times", 15))
        self.frm_right_gear_f2_data = pytk.PyLabel(self.frm_right_gear_f2, text="",
                                                        width=17, font=("Times", 15))
        self.frm_right_gear_f2_label.grid(row=0, column=0, padx=0, pady=0, sticky="w")
        self.frm_right_gear_f2_data.grid(row=1, column=0, padx=0, pady=0, sticky="w")

        self.frm_right_gear_f3_label = pytk.PyLabel(self.frm_right_gear_f3, text="F3变速比：",
                                                    width=17, font=("Times", 15))
        self.frm_right_gear_f3_data = pytk.PyLabel(self.frm_right_gear_f3, text="",
                                                   width=17, font=("Times", 15))
        self.frm_right_gear_f3_label.grid(row=0, column=0, padx=0, pady=0, sticky="w")
        self.frm_right_gear_f3_data.grid(row=1, column=0, padx=0, pady=0, sticky="w")

        self.frm_right_gear_f4_label = pytk.PyLabel(self.frm_right_gear_f4, text="F4变速比：",
                                                    width=17, font=("Times", 15))
        self.frm_right_gear_f4_data = pytk.PyLabel(self.frm_right_gear_f4, text="",
                                                   width=17, font=("Times", 15))
        self.frm_right_gear_f4_label.grid(row=0, column=0, padx=0, pady=0, sticky="w")
        self.frm_right_gear_f4_data.grid(row=1, column=0, padx=0, pady=0, sticky="w")

        self.frm_right_gear_r1_label = pytk.PyLabel(self.frm_right_gear_r1, text="R1变速比：",
                                                    width=17, font=("Times", 15))
        self.frm_right_gear_r1_data = pytk.PyLabel(self.frm_right_gear_r1, text="",
                                                   width=17, font=("Times", 15))
        self.frm_right_gear_r1_label.grid(row=0, column=0, padx=0, pady=0, sticky="w")
        self.frm_right_gear_r1_data.grid(row=1, column=0, padx=0, pady=0, sticky="w")

        self.frm_right_gear_r2_label = pytk.PyLabel(self.frm_right_gear_r2, text="R2变速比：",
                                                    width=17, font=("Times", 15))
        self.frm_right_gear_r2_data = pytk.PyLabel(self.frm_right_gear_r2, text="",
                                                   width=17, font=("Times", 15))
        self.frm_right_gear_r2_label.grid(row=0, column=0, padx=0, pady=0, sticky="w")
        self.frm_right_gear_r2_data.grid(row=1, column=0, padx=0, pady=0, sticky="w")

        self.frm_right_gear_r3_label = pytk.PyLabel(self.frm_right_gear_r3, text="R3变速比：",
                                                    width=17, font=("Times", 15))
        self.frm_right_gear_r3_data = pytk.PyLabel(self.frm_right_gear_r3, text="",
                                                   width=17, font=("Times", 15))
        self.frm_right_gear_r3_label.grid(row=0, column=0, padx=0, pady=0, sticky="w")
        self.frm_right_gear_r3_data.grid(row=1, column=0, padx=0, pady=0, sticky="w")

    # 框架 状态栏
    def create_frm_status(self):
        self.frm_status_label = pytk.PyLabel(self.frm_status,
                                             text="Mysql status：已连接到数据库loaderdb",
                                             font=g_font)
        self.frm_status_label.grid(row=0, column=0, padx=5, pady=5, sticky="wesn")

    # Mysql连接
    def mysql_connect(self):
        try:
            conn.select_db('loaderdb')
            # 发动机
            sql_engine = "SELECT CarName FROM carinfo"
            cur = conn.cursor()
            cur.execute(sql_engine)
            stus = cur.fetchall()
            conn.commit()
            cur.close()
            self._listcar = []
            if stus:
                for i in range(len(stus)):
                    name = stus[i]["CarName"]
                    self._listcar.append(name)
            else:
                self._listcar.append("NULL")
        except MySQLdb.Error, e:
            tkMessageBox.showinfo("状态：", u"MySQL Error： %d:%s" % (e.args[0], e.args[1]))
            self.frm_status_label["text"] = u"MySQL Error： 数据库连接错误！"

    # MYSQL查询
    def mysql_inquiry(self, input_table):
        try:
            table = input_table[0]
            column = input_table[1]
            data = input_table[2]
            # 查询语句
            sql_inquery = "SELECT * FROM {0} WHERE {1} = '{2}'".format(table, column, data)
            # 游标，执行，返回stus
            cur = conn.cursor()
            cur.execute(sql_inquery)
            stus = cur.fetchall()
            # 提交
            conn.commit()
            # 关闭游标
            cur.close()
            return stus
        except MySQLdb.Error, e:
            tkMessageBox.showinfo("状态：", u"MySQL Error： %d:%s" % (e.args[0], e.args[1]))
            self.frm_status_label["text"] = u"MySQL Error： %d:%s" % (e.args[0], e.args[1])

    # OPTIONMENU
    def Opt_car(self, event):
        # 显示图片
        self.rbtn_bujian()
        # 查询编号
        carname = self._var1.get()
        sql_car = "SELECT EngineName,TurbineName,GearName,CarframeName FROM carinfo WHERE CarName = '{0}'".format(carname)
        cur = conn.cursor()
        cur.execute(sql_car)
        stus_car = cur.fetchall()
        conn.commit()
        if stus_car:
            self._enginename = stus_car[0]['EngineName']
            self._turbinename = stus_car[0]['TurbineName']
            self._gearname = stus_car[0]['GearName']
            self._carframename = stus_car[0]['CarframeName']
            global show_enginename, show_turbinename
            show_enginename = self._enginename
            show_turbinename = self._turbinename
            # 车架
            input_carframe = ['carframeinfo', 'CarframeName', self._carframename]
            stus_carframe = self.mysql_inquiry(input_carframe)
            if stus_carframe:
                speedratio = stus_carframe[0]['DriveAxleSpeedRatio']
                roll = stus_carframe[0]['Roll']
                MaxV = stus_carframe[0]['MaxV']
                MaxF = stus_carframe[0]['MaxF']
                WeightEmpty = stus_carframe[0]['WeightEmpty']
                WeightFull = stus_carframe[0]['WeightFull']
                self.frm_left_carframe_speedratio_data["text"] = speedratio
                self.frm_left_carframe_roll_data["text"] = roll
                self.frm_left_carframe_maxv_data["text"] = MaxV
                self.frm_left_carframe_maxf_data["text"] = MaxF
                self.frm_left_carframe_weightempty_data["text"] = WeightEmpty
                self.frm_left_carframe_weightfull_data["text"] = WeightFull
                self.frm_left_carframe_name_data["text"] = self._carframename

            # 发动机参数
            input_engine = ['engineinfo', 'EngineName', self._enginename]
            stus_engine = self.mysql_inquiry(input_engine)
            if stus_engine:
                RatedPower = stus_engine[0]['RatedPower']
                RatedSpeed = stus_engine[0]['RatedSpeed']
                MaxTorqueSpeed = stus_engine[0]['MaxTorqueSpeed']
                MaxTorque = stus_engine[0]['MaxTorque']
                NumCylinder = stus_engine[0]['NumCylinder']
                DCylinder = stus_engine[0]['DCylinder']
                PistonDisplacement = stus_engine[0]['PistonDisplacement']
                PistonStroke = stus_engine[0]['PistonStroke']
                CompressionRatio = stus_engine[0]['CompressionRatio']
                Lengthx = stus_engine[0]['Lengthx']
                Width = stus_engine[0]['Width']
                Height = stus_engine[0]['Height']
                Weight = stus_engine[0]['Weight']

                self.frm_right_engine_name_data["text"] = self._enginename
                self.frm_right_engine_ratedpower_data["text"] = RatedPower
                self.frm_right_engine_ratedspeed_data["text"] = RatedSpeed
                self.frm_right_engine_maxtorquespeed_data["text"] = MaxTorqueSpeed
                self.frm_right_engine_maxtorque_data["text"] = MaxTorque
                self.frm_right_engine_numcylinder_data["text"] = NumCylinder
                self.frm_right_engine_dcylinder_data["text"] = DCylinder
                self.frm_right_engine_pistondisplacement_data["text"] = PistonDisplacement
                self.frm_right_engine_pistonstroke_data["text"] = PistonStroke
                self.frm_right_engine_compressionratio_data["text"] = CompressionRatio
                self.frm_right_engine_lengthx_data ["text"] = Lengthx
                self.frm_right_engine_width_data["text"] = Width
                self.frm_right_engine_height_data["text"] = Height
                self.frm_right_engine_weight_data["text"] = Weight
            # 液力变矩器参数
            input_turbine = ['turbineinfo', 'TurbineName', self._turbinename]
            stus_turbine = self.mysql_inquiry(input_turbine)
            if stus_turbine:
                TurbineD = stus_turbine[0]['TurbineD']
                TurbineRatedSpeed = stus_turbine[0]['TurbineRatedSpeed']
                TurbineMaxTorque = stus_turbine[0]['TurbineMaxTorque']
                TurbineRatePower = stus_turbine[0]['TurbineRatedPower']
                self.frm_right_turbine_d_data["text"] = TurbineD
                self.frm_right_turbine_ratedspeed_data["text"] = TurbineRatedSpeed
                self.frm_right_turbine_ratedpower_data["text"] = TurbineRatePower
                self.frm_right_turbine_maxtorque_data["text"] = TurbineMaxTorque
                self.frm_right_turbine_name_data["text"] = self._turbinename
            # 变速箱参数
            input_gear = ['gearinfo', 'GearName', self._gearname]
            stus_gear = self.mysql_inquiry(input_gear)
            if stus_gear:
                F1 = stus_gear[0]['F1']
                F2 = stus_gear[0]['F2']
                F3 = stus_gear[0]['F3']
                F4 = stus_gear[0]['F4']
                R1 = stus_gear[0]['R1']
                R2 = stus_gear[0]['R2']
                R3 = stus_gear[0]['R3']
                self.frm_right_gear_f1_data["text"] = F1
                self.frm_right_gear_f2_data["text"] = F2
                self.frm_right_gear_f3_data["text"] = F3
                self.frm_right_gear_f4_data["text"] = F4
                self.frm_right_gear_r1_data["text"] = R1
                self.frm_right_gear_r2_data["text"] = R2
                self.frm_right_gear_r3_data["text"] = R3
                self.frm_right_gear_name_data["text"] = self._gearname

    # 返回主菜单
    def Back_main_menu(self):
        self.withdraw()
        MainWindow(self)

    # 形状参数
    def rbtn_chicun(self):
        carname = self._var1.get()
        if carname:
            STR_S_XZ = "pic//{0}-S-XZ.jpg".format(carname)
            STR_Z_XZ = "pic//{0}-Z-XZ.jpg".format(carname)

            pil_image = Image.open(STR_S_XZ)
            # 缩放图像让它保持比例，同时限制在一个矩形框范围内
            pil_image_resized = pil_image.resize((400, 300), Image.ANTIALIAS)
            self._tk_image = ImageTk.PhotoImage(pil_image_resized)
            self.frm_right_carpic_pic_pic = pytk.PyLabel(self.frm_right_carpic_pic, image=self._tk_image)
            self.frm_right_carpic_pic_pic.grid(row=0, column=0, pady=0, padx=0, sticky="wesn")

            pil_image1 = Image.open(STR_Z_XZ)
            # 缩放图像让它保持比例，同时限制在一个矩形框范围内
            pil_image_resized1 = pil_image1.resize((400, 300), Image.ANTIALIAS)
            self._tk_image1 = ImageTk.PhotoImage(pil_image_resized1)
            self.frm_right_carpic_pic_pic1 = pytk.PyLabel(self.frm_right_carpic_pic, image=self._tk_image1)
            self.frm_right_carpic_pic_pic1.grid(row=0, column=1, pady=0, padx=0, sticky="wesn")

    # 部件参数
    def rbtn_bujian(self):
        carname = self._var1.get()
        if carname:
            STR_S_BJ = "pic//{0}-S-BJ.jpg".format(carname)
            STR_Z_BJ = "pic//{0}-Z-BJ.jpg".format(carname)

            pil_image = Image.open(STR_S_BJ)
            # 缩放图像让它保持比例，同时限制在一个矩形框范围内
            pil_image_resized = pil_image.resize((400, 300), Image.ANTIALIAS)
            self._tk_image = ImageTk.PhotoImage(pil_image_resized)
            self.frm_right_carpic_pic_pic = pytk.PyLabel(self.frm_right_carpic_pic, image=self._tk_image)
            self.frm_right_carpic_pic_pic.grid(row=0, column=0, pady=0, padx=0, sticky="wesn")

            pil_image1 = Image.open(STR_Z_BJ)
            # 缩放图像让它保持比例，同时限制在一个矩形框范围内
            pil_image_resized1 = pil_image1.resize((400, 300), Image.ANTIALIAS)
            self._tk_image1 = ImageTk.PhotoImage(pil_image_resized1)
            self.frm_right_carpic_pic_pic1 = pytk.PyLabel(self.frm_right_carpic_pic, image=self._tk_image1)
            self.frm_right_carpic_pic_pic1.grid(row=0, column=1, pady=0, padx=0, sticky="wesn")

    # 发动机曲线
    def Btn_enginecurve(self):
        if self._var1.get():
            self.withdraw()
            Show_engine(self)
        else:
            tkMessageBox.showinfo("提示：", "请选择车辆型号！")

    # 液力变矩器曲线
    def Btn_turbinecurve(self):
        if self._var1.get():
            self.withdraw()
            Show_turbinecurve(self)
        else:
            tkMessageBox.showinfo("提示：", "请选择车辆型号！")

    # 牵引力曲线
    def Btn_traction(self):
        if self._var1.get():
            self.withdraw()
            Show_traction(self)
        else:
            tkMessageBox.showinfo("提示：", "请选择车辆型号！")

    def show(self):
        self.update()
        self.deiconify()

# 发动机曲线
class Show_engine(tk.Toplevel):
    # 初始化函数
    def __init__(self, master=None):
        tk.Toplevel.__init__(self)
        self.original_frame = master
        self.resizable(False, False)
        self.title("车辆信息管理")
        self.mysql_connect()
        self.create_frame()

    # 总体框架【上下】
    def create_frame(self):
        self.frm = pytk.PyLabelFrame(self)
        self.frm_status = pytk.PyLabelFrame(self)

        self.frm.grid(row=0, column=0, sticky="wesn")
        self.frm_status.grid(row=1, column=0, sticky="wesn")

        self.create_frm()
        self.create_frm_status()

        # 总体框架【左右】

    # 总体框架【上】
    def create_frm(self):
        self.frm_left = pytk.PyLabelFrame(self.frm)
        self.frm_right = pytk.PyLabelFrame(self.frm)

        self.frm_left.grid(row=0, column=0, padx=5, pady=5, sticky="wesn")
        self.frm_right.grid(row=0, column=1, padx=5, pady=5, sticky="wesn")

        self.create_frm_left()
        self.create_frm_right()


        # 框架 左

    # 框架【左】
    def create_frm_left(self):
        # 选择
        self.frm_left_select = pytk.PyLabelFrame(self.frm_left)
        self.frm_select_label = pytk.PyLabel(self.frm_left_select, width=17, text="实验组别：", font=("Times", 15))
        self._var1 = tk.StringVar()
        self.frm_left_engine_optionmenu = tk.OptionMenu(self.frm_left_select, self._var1,
                                                     *self._listengine)
        self.frm_left_engine_optionmenu.config(font=('Times', 15), bg="#292929", fg="#E0EEEE", width=15)
        self.frm_left_engine_optionmenu.bind('<Button-1>', self.Opt_engine)

        self.frm_left_select.grid(row=1, column=0, padx=20, pady=20, sticky="w")
        self.frm_select_label.grid(row=0, column=0, sticky="w")
        self.frm_left_engine_optionmenu.grid(row=1, column=0, sticky="wsne")

        # 发动机型号
        self.frm_left_engine = pytk.PyLabelFrame(self.frm_left)
        self.frm_left_engine.grid(row=0, column=0, padx=20, pady=20, sticky="wsne")
        self.frm_left_engine_label = pytk.PyLabel(self.frm_left_engine, text="发动机型号：",
                                                         width=17, font=("Times", 15))
        self.frm_left_engine_data = pytk.PyLabel(self.frm_left_engine, text=show_enginename,
                                                        width=17, font=("Times", 15))
        self.frm_left_engine_label.grid(row=0, column=0, padx=0, pady=0, sticky="w")
        self.frm_left_engine_data.grid(row=1, column=0, padx=0, pady=0, sticky="w")

        # 退出
        self.frm_left_quit = pytk.PyLabelFrame(self.frm_left)
        self.frm_left_quit.grid(row=2, column=0, padx=20, pady=20, sticky="w")
        self.frm_left_quit_btn = pytk.PyButton(self.frm_left_quit,
                                               text="返回主菜单",
                                               height=2,
                                               font=g_font,
                                               command=self.Back_main_menu)
        self.frm_left_quit_btn.grid(row=1, column=0, padx=50, sticky="wesn")

    # 框架 右
    def create_frm_right(self):
        # 在Tk的GUI上放置一个画布，并用.grid()来调整布局
        self.draw = Figure(figsize=(8, 5), dpi=100)
        self.draw.canvas = FigureCanvasTkAgg(self.draw, self.frm_right)
        self.draw.canvas.show()
        self.frm_right_label = pytk.PyLabel(self.frm_right,
                                           text="发动机特性曲线：",
                                           font=("Times", 15))
        self.frm_right_label.grid(row=0, column=0, padx=0, pady=0, sticky="w")
        self.draw.canvas.get_tk_widget().grid(row=1, columnspan=3)

    # 框架 状态栏
    def create_frm_status(self):
        self.frm_status_label = pytk.PyLabel(self.frm_status,
                                             text="Mysql status：已连接到数据库loaderdb",
                                             font=g_font)
        self.frm_status_label.grid(row=0, column=0, padx=5, pady=5, sticky="wesn")

    # 返回主菜单
    def Back_main_menu(self):
        self.withdraw()
        self.original_frame.show()

    # Mysql连接
    def mysql_connect(self):
        try:
            # 查询语句
            sql_inquery = "SELECT EngineGroupx FROM enginecurve WHERE EngineName = '{0}'".format(show_enginename)
            # 游标，执行，返回 stus
            cur = conn.cursor()
            cur.execute(sql_inquery)
            stus = cur.fetchall()
            # 提交
            conn.commit()
            # 关闭游标
            cur.close()
            # 显示
            self._listengine = []
            data_indexs = []
            if stus:
                for i in range(len(stus)):
                    indexs = stus[i]["EngineGroupx"]
                    data_indexs.append(indexs)
                data_indexs = sorted(set(data_indexs), key=data_indexs.index)
                for i in range(len(data_indexs)):
                    self._listengine.append(data_indexs[i])
            else:
                self._listengine.append("NULL")
        except MySQLdb.Error, e:
            tkMessageBox.showinfo("状态：", u"MySQL Error： %d:%s" % (e.args[0], e.args[1]))
            self.frm_status_label["text"] = u"MySQL Error： %d:%s" % (e.args[0], e.args[1])
            self.frm_status_label["text"] = u"Mysql status：表单连接失败！"

    # Opt_engine
    def Opt_engine(self, event):
        # 查询编号
        groupx = self._var1.get()
        sql_engine = "SELECT Me,P,ge,n FROM enginecurve WHERE EngineName = '{0}' AND EngineGroupx = '{1}'".format(
            show_enginename, groupx)
        cur = conn.cursor()
        cur.execute(sql_engine)
        stus_car = cur.fetchall()
        conn.commit()
        self._Me = []
        self._ge = []
        self._n = []
        self._P = []
        if stus_car:
            for i in range(len(stus_car)):
                self._Me.append(stus_car[i]['Me'])
                self._P.append(stus_car[i]['P'])
                self._ge.append(stus_car[i]['ge'])
                self._n.append(stus_car[i]['n'])
            self._data = {}
            self._data[0] = self._Me
            self._data[1] = self._ge
            self._data[2] = self._P
            # 画图
            self.draw.clf()
            self.draw_a = self.draw.add_subplot(111)
            Colorx = ['r', 'b', 'g']
            Namex = ['转矩(Me)', '油耗(ge)', '功率(P)']
            for i in range(3):
                x = self._n
                y = self._data[i]
                self.draw_a.plot(x, y, color = Colorx[i], linewidth=3)
                self.draw_a.legend((Namex[0], Namex[1], Namex[2],),loc='upper left')  # 加一个逗号》》元组类型
            self.draw_a.set_ylabel("数值")
            self.draw_a.set_xlabel("转速")
            self.draw_a.set_title("发动机特性曲线")
            self.draw.canvas.show()

# 液力变矩器曲线
class Show_turbinecurve(tk.Toplevel):
    # 初始化函数
    def __init__(self, master):
        tk.Toplevel.__init__(self)
        self.original_frame = master
        self.resizable(False, False)
        self.title("车辆信息管理")
        self.mysql_connect()
        self.create_frame()

    # 总体框架【上下】
    def create_frame(self):
        self.frm = pytk.PyLabelFrame(self)
        self.frm_status = pytk.PyLabelFrame(self)

        self.frm.grid(row=0, column=0, sticky="wesn")
        self.frm_status.grid(row=1, column=0, sticky="wesn")

        self.create_frm()
        self.create_frm_status()

    # 总体框架【上】
    def create_frm(self):
        self.frm_left = pytk.PyLabelFrame(self.frm)
        self.frm_right = pytk.PyLabelFrame(self.frm)

        self.frm_left.grid(row=0, column=0, padx=5, pady=5, sticky="wesn")
        self.frm_right.grid(row=0, column=1, padx=5, pady=5, sticky="wesn")

        self.create_frm_left()
        self.create_frm_right()

    # 框架【左】
    def create_frm_left(self):
        # 选择
        self.frm_left_select = pytk.PyLabelFrame(self.frm_left)
        self.frm_select_label = pytk.PyLabel(self.frm_left_select, width=17, text="实验组别：", font=("Times", 15))
        self._var1 = tk.StringVar()
        self.frm_left_turbine_optionmenu = tk.OptionMenu(self.frm_left_select, self._var1,
                                                        *self._listturbine)
        self.frm_left_turbine_optionmenu.config(font=('Times', 15), bg="#292929", fg="#E0EEEE", width=15)
        self.frm_left_turbine_optionmenu.bind('<Button-1>', self.Opt_turbine)

        self.frm_left_select.grid(row=1, column=0, padx=20, pady=20, sticky="w")
        self.frm_select_label.grid(row=0, column=0, sticky="w")
        self.frm_left_turbine_optionmenu.grid(row=1, column=0, sticky="wsne")

        # 发动机型号
        self.frm_left_turbine = pytk.PyLabelFrame(self.frm_left)
        self.frm_left_turbine.grid(row=0, column=0, padx=20, pady=20, sticky="wsne")
        self.frm_left_turbine_label = pytk.PyLabel(self.frm_left_turbine, text="液力变矩器型号：",
                                                  width=17, font=("Times", 15))
        self.frm_left_turbine_data = pytk.PyLabel(self.frm_left_turbine, text=show_turbinename,
                                                 width=17, font=("Times", 15))
        self.frm_left_turbine_label.grid(row=0, column=0, padx=0, pady=0, sticky="w")
        self.frm_left_turbine_data.grid(row=1, column=0, padx=0, pady=0, sticky="w")

        # 退出
        self.frm_left_quit = pytk.PyLabelFrame(self.frm_left)
        self.frm_left_quit.grid(row=2, column=0, padx=20, pady=20, sticky="w")
        self.frm_left_quit_btn = pytk.PyButton(self.frm_left_quit,
                                               text="返回主菜单",
                                               height=2,
                                               font=g_font,
                                               command=self.Back_main_menu)
        self.frm_left_quit_btn.grid(row=1, column=0, padx=50, sticky="wesn")

    # 框架 右
    def create_frm_right(self):
        # 在Tk的GUI上放置一个画布，并用.grid()来调整布局
        self.draw = Figure(figsize=(5, 8), dpi=100)
        self.draw.canvas = FigureCanvasTkAgg(self.draw, self.frm_right)
        self.draw.canvas.show()
        self.frm_right_label = pytk.PyLabel(self.frm_right,
                                            text="液力变矩器特性曲线：",
                                            font=("Times", 15))
        self.frm_right_label.grid(row=0, column=0, padx=0, pady=0, sticky="w")
        self.draw.canvas.get_tk_widget().grid(row=1, columnspan=3)

    # 框架 状态栏
    def create_frm_status(self):
        self.frm_status_label = pytk.PyLabel(self.frm_status,
                                             text="Mysql status：已连接到数据库loaderdb",
                                             font=g_font)
        self.frm_status_label.grid(row=0, column=0, padx=5, pady=5, sticky="wesn")

    # 返回主菜单
    def Back_main_menu(self):
        self.withdraw()
        self.original_frame.show()

    # Mysql连接
    def mysql_connect(self):
        try:
            # 查询语句
            sql_inquery = "SELECT TurbineGroupx FROM turbinecurve WHERE TurbineName = '{0}'".format(
                show_turbinename)
            # 游标，执行，返回 stus
            cur = conn.cursor()
            cur.execute(sql_inquery)
            stus = cur.fetchall()
            # 提交
            conn.commit()
            # 关闭游标
            cur.close()
            # 显示
            self._listturbine = []
            data_indexs = []
            if stus:
                for i in range(len(stus)):
                    indexs = stus[i]["TurbineGroupx"]
                    data_indexs.append(indexs)
                data_indexs = sorted(set(data_indexs), key=data_indexs.index)
                for i in range(len(data_indexs)):
                    self._listturbine.append(data_indexs[i])
            else:
                self._listturbine.append("NULL")
        except MySQLdb.Error, e:
            tkMessageBox.showinfo("状态：", u"MySQL Error： %d:%s" % (e.args[0], e.args[1]))
            self.frm_status_label["text"] = u"MySQL Error： %d:%s" % (e.args[0], e.args[1])
            self.frm_status_label["text"] = u"Mysql status：表单连接失败！"

    # Opt_turbine
    def Opt_turbine(self, event):
        # 查询编号
        groupx = self._var1.get()
        sql_engine = "SELECT K,i,nt,Mt,lamda FROM turbinecurve WHERE TurbineName = '{0}' AND TurbineGroupx = '{1}'".format(
            show_turbinename, groupx)
        cur = conn.cursor()
        cur.execute(sql_engine)
        stus_car = cur.fetchall()
        conn.commit()
        self._K = []
        self._i = []
        self._nt = []
        self._Mt = []
        self._lamda = []
        if stus_car:
            for i in range(len(stus_car)):
                self._K.append(stus_car[i]['K'])
                self._i.append(stus_car[i]['i'])
                self._nt.append(stus_car[i]['nt'])
                self._Mt.append(stus_car[i]['Mt'])
                self._lamda.append(stus_car[i]['lamda'])
            self._data = {}
            self._data[0] = self._K
            self._data[1] = self._nt
            self._data[2] = self._Mt
            self._data[3] = self._lamda
            # 画图
            self.draw.clf()
            Colorx = ['r', 'b', 'g', 'k']
            Namex = ['K', 'nt', 'Mt', 'lamda']
            for i in range(4):
                numstr = 411 + i
                self.draw_a = self.draw.add_subplot(numstr)
                x = self._i
                y = self._data[i]
                self.draw_a.plot(x, y, color=Colorx[i], linewidth=3)
                self.draw_a.legend((Namex[i],), loc='upper left')  # 加一个逗号》》元组类型
                if i == 0:
                    self.draw_a.set_title("液力变矩器特性曲线")
                if i == 3:
                    self.draw_a.set_xlabel("i")
            self.draw.canvas.show()

# 牵引力特性曲线
class Show_traction(tk.Toplevel):
    # 初始化函数
    def __init__(self, master=None):
        tk.Toplevel.__init__(self)
        self.original_frame = master
        self.resizable(False, False)
        self.title("车辆信息管理")
        self.mysql_connect()
        self.create_frame()

    # 总体框架【上下】
    def create_frame(self):
        self.frm = pytk.PyLabelFrame(self)
        self.frm_status = pytk.PyLabelFrame(self)

        self.frm.grid(row=0, column=0, sticky="wesn")
        self.frm_status.grid(row=1, column=0, sticky="wesn")

        self.create_frm()
        self.create_frm_status()

    # 总体框架【上】
    def create_frm(self):
        self.frm_left = pytk.PyLabelFrame(self.frm)
        self.frm_right = pytk.PyLabelFrame(self.frm)

        self.frm_left.grid(row=0, column=0, padx=5, pady=5, sticky="wesn")
        self.frm_right.grid(row=0, column=1, padx=5, pady=5, sticky="wesn")

        self.create_frm_left()
        self.create_frm_right()

    # 框架【左】
    def create_frm_left(self):
        # 选择
        self.frm_left_select = pytk.PyLabelFrame(self.frm_left)
        self.frm_select_label = pytk.PyLabel(self.frm_left_select, width=17, text="实验组别：",
                                             font=("Times", 15))
        self._var1 = tk.StringVar()
        self.frm_left_traction_optionmenu = tk.OptionMenu(self.frm_left_select, self._var1,
                                                        *self._listtraction)
        self.frm_left_traction_optionmenu.config(font=('Times', 15), bg="#292929", fg="#E0EEEE",
                                               width=15)
        self.frm_left_traction_optionmenu.bind('<Button-1>', self.Opt_traction)

        self.frm_left_select.grid(row=1, column=0, padx=20, pady=20, sticky="w")
        self.frm_select_label.grid(row=0, column=0, sticky="w")
        self.frm_left_traction_optionmenu.grid(row=1, column=0, sticky="wsne")

        # 发动机型号
        self.frm_left_turbine = pytk.PyLabelFrame(self.frm_left)
        self.frm_left_turbine.grid(row=0, column=0, padx=20, pady=20, sticky="wsne")
        self.frm_left_turbine_label = pytk.PyLabel(self.frm_left_turbine, text="液力变矩器型号：",
                                                  width=17, font=("Times", 15))
        self.frm_left_turbine_data = pytk.PyLabel(self.frm_left_turbine, text=show_turbinename,
                                                 width=17, font=("Times", 15))
        self.frm_left_turbine_label.grid(row=0, column=0, padx=0, pady=0, sticky="w")
        self.frm_left_turbine_data.grid(row=1, column=0, padx=0, pady=0, sticky="w")

        # rbtn
        self.frm_left_rbtn = pytk.PyLabelFrame(self.frm_left)
        self.frm_left_rbtn.grid(row=2, column=0, padx=20, pady=20, sticky="w")
        self._radio_intvar = tk.IntVar()
        self.frm_rbtn_f = pytk.PyRadiobutton(self.frm_left_rbtn, text="车速-牵引力", variable=self._radio_intvar,
                                                value=0, font=("Monaco", 15), command=self.rbtn_f)
        self.frm_rbtn_alpha = pytk.PyRadiobutton(self.frm_left_rbtn, text="车速-爬坡度", variable=self._radio_intvar,
                                               value=1, font=("Monaco", 15), command=self.rbtn_alpha)
        self.frm_rbtn_gradent = pytk.PyRadiobutton(self.frm_left_rbtn, text="车速-道路坡度", variable=self._radio_intvar,
                                               value=2, font=("Monaco", 15), command=self.rbtn_gradent)
        self.frm_rbtn_efficiency = pytk.PyRadiobutton(self.frm_left_rbtn, text="车速-效率", variable=self._radio_intvar,
                                               value=3, font=("Monaco", 15), command=self.rbtn_efficiency)
        self.frm_rbtn_f.grid(row=0, column=0, padx=20, pady=20, sticky="w")
        self.frm_rbtn_alpha.grid(row=1, column=0, padx=20, pady=20, sticky="w")
        self.frm_rbtn_gradent.grid(row=2, column=0, padx=20, pady=20, sticky="w")
        self.frm_rbtn_efficiency.grid(row=3, column=0, padx=20, pady=20, sticky="w")


        # 退出
        self.frm_left_quit = pytk.PyLabelFrame(self.frm_left)
        self.frm_left_quit.grid(row=3, column=0, padx=20, pady=20, sticky="w")
        self.frm_left_quit_btn = pytk.PyButton(self.frm_left_quit,
                                               text="返回主菜单",
                                               height=2,
                                               font=g_font,
                                               command=self.Back_main_menu)
        self.frm_left_quit_btn.grid(row=1, column=0, padx=50, sticky="wesn")

    # 框架 右
    def create_frm_right(self):
        # 在Tk的GUI上放置一个画布，并用.grid()来调整布局
        self.draw = Figure(figsize=(8, 6), dpi=100)
        self.draw.canvas = FigureCanvasTkAgg(self.draw, self.frm_right)
        self.draw.canvas.show()
        self.frm_right_label = pytk.PyLabel(self.frm_right,
                                            text="牵引力特性曲线：",
                                            font=("Times", 15))
        self.frm_right_label.grid(row=0, column=0, padx=0, pady=0, sticky="w")
        self.draw.canvas.get_tk_widget().grid(row=1, columnspan=3)

    # 框架 状态栏
    def create_frm_status(self):
        self.frm_status_label = pytk.PyLabel(self.frm_status,
                                             text="Mysql status：已连接到数据库loaderdb",
                                             font=g_font)
        self.frm_status_label.grid(row=0, column=0, padx=5, pady=5, sticky="wesn")

    # 返回主菜单
    def Back_main_menu(self):
        self.withdraw()
        self.original_frame.show()

    # Mysql连接
    def mysql_connect(self):
        try:
            # 查询语句
            sql_inquery = "SELECT TractionGroupx FROM tractionefficiency WHERE TurbineName = '{0}'".format(
                show_turbinename)
            # 游标，执行，返回 stus
            cur = conn.cursor()
            cur.execute(sql_inquery)
            stus = cur.fetchall()
            # 提交
            conn.commit()
            # 关闭游标
            cur.close()
            # 显示
            self._listtraction = []
            data_indexs = []
            if stus:
                for i in range(len(stus)):
                    indexs = stus[i]["TractionGroupx"]
                    data_indexs.append(indexs)
                data_indexs = sorted(set(data_indexs), key=data_indexs.index)
                for i in range(len(data_indexs)):
                    self._listtraction.append(data_indexs[i])
            else:
                self._listtraction.append("NULL")
        except MySQLdb.Error, e:
            tkMessageBox.showinfo("状态：", u"MySQL Error： %d:%s" % (e.args[0], e.args[1]))
            self.frm_status_label["text"] = u"MySQL Error： %d:%s" % (e.args[0], e.args[1])
            self.frm_status_label["text"] = u"Mysql status：表单连接失败！"

    # Opt_traction
    def Opt_traction(self, event):
        # 查询编号
        groupx = self._var1.get()
        sql_turbine = "SELECT VF1,FF1,GradientF1,alphaF1,VF2,FF2,GradientF2,alphaF2,VF3,FF3,GradientF3,alphaF3,VF4,FF4,GradientF4,alphaF4,efficiency FROM tractionefficiency WHERE TurbineName = '{0}' AND TractionGroupx = '{1}'".format(
            show_turbinename, groupx)
        cur = conn.cursor()
        cur.execute(sql_turbine)
        stus_car = cur.fetchall()
        conn.commit()
        self._VF1 = []
        self._FF1 = []
        self._GradientF1 = []
        self._alphaF1 = []
        self._VF2 = []
        self._FF2 = []
        self._GradientF2 = []
        self._alphaF2 = []
        self._VF3 = []
        self._FF3 = []
        self._GradientF3 = []
        self._alphaF3 = []
        self._VF4 = []
        self._FF4 = []
        self._GradientF4 = []
        self._alphaF4 = []
        self._efficiency = []
        if stus_car:
            for i in range(len(stus_car)):
                self._VF1.append(stus_car[i]['VF1'])
                self._FF1.append(stus_car[i]['FF1'])
                self._GradientF1.append(stus_car[i]['GradientF1'])
                self._alphaF1.append(stus_car[i]['alphaF1'])
                self._VF2.append(stus_car[i]['VF2'])
                self._FF2.append(stus_car[i]['FF2'])
                self._GradientF2.append(stus_car[i]['GradientF2'])
                self._alphaF2.append(stus_car[i]['alphaF2'])
                self._VF3.append(stus_car[i]['VF3'])
                self._FF3.append(stus_car[i]['FF3'])
                self._GradientF3.append(stus_car[i]['GradientF3'])
                self._alphaF3.append(stus_car[i]['alphaF3'])
                self._VF4.append(stus_car[i]['VF4'])
                self._FF4.append(stus_car[i]['FF4'])
                self._GradientF4.append(stus_car[i]['GradientF4'])
                self._alphaF4.append(stus_car[i]['alphaF4'])
                self._efficiency.append(stus_car[i]['efficiency'])

    # 牵引力
    def rbtn_f(self):
        y = {}
        y[0] = self._FF1
        y[1] = self._FF2
        y[2] = self._FF3
        y[3] = self._FF4
        x = {}
        x[0] = self._VF1
        x[1] = self._VF2
        x[2] = self._VF3
        x[3] = self._VF4
        # 画图
        self.draw.clf()
        self.draw_a = self.draw.add_subplot(111)
        Colorx = ['r', 'b', 'g' , 'k']
        Namex = ['1挡牵引力', '2挡牵引力', '3挡牵引力', '4挡牵引力']
        for i in range(4):
            self.draw_a.plot(x[i], y[i], color=Colorx[i], linewidth=3)
        self.draw_a.legend((Namex[0], Namex[1], Namex[2], Namex[3],), loc='upper left')  # 加一个逗号》》元组类型
        self.draw_a.set_xlabel("速度(m/s)")
        self.draw_a.set_ylabel("牵引力(N)")
        self.draw_a.set_title("车速-牵引力")
        self.draw.canvas.show()

    # 爬坡度
    def rbtn_alpha(self):
        y = {}
        y[0] = self._alphaF1
        y[1] = self._alphaF2
        y[2] = self._alphaF3
        y[3] = self._alphaF4
        x = {}
        x[0] = self._VF1
        x[1] = self._VF2
        x[2] = self._VF3
        x[3] = self._VF4
        # 画图
        self.draw.clf()
        self.draw_a = self.draw.add_subplot(111)
        Colorx = ['r', 'b', 'g', 'k']
        Namex = ['1挡爬坡度', '2挡爬坡度', '3挡爬坡度', '4挡爬坡度']
        for i in range(4):
            self.draw_a.plot(x[i], y[i], color=Colorx[i], linewidth=3)
        self.draw_a.legend((Namex[0], Namex[1], Namex[2], Namex[3],), loc='upper left')  # 加一个逗号》》元组类型
        self.draw_a.set_xlabel("速度(m/s)")
        self.draw_a.set_ylabel("爬坡度(°)")
        self.draw_a.set_title("车速-爬坡度")
        self.draw.canvas.show()

    # 道路坡度
    def rbtn_gradent(self):
        y = {}
        y[0] = self._GradientF1
        y[1] = self._GradientF2
        y[2] = self._GradientF3
        y[3] = self._GradientF4
        x = {}
        x[0] = self._VF1
        x[1] = self._VF2
        x[2] = self._VF3
        x[3] = self._VF4
        # 画图
        self.draw.clf()
        self.draw_a = self.draw.add_subplot(111)
        Colorx = ['r', 'b', 'g', 'k']
        Namex = ['1挡道路坡度', '2挡道路坡度', '3挡道路坡度', '4挡道路坡度']
        for i in range(4):
            self.draw_a.plot(x[i], y[i], color=Colorx[i], linewidth=3)
        self.draw_a.legend((Namex[0], Namex[1], Namex[2], Namex[3],), loc='upper left')  # 加一个逗号》》元组类型
        self.draw_a.set_xlabel("速度(m/s)")
        self.draw_a.set_ylabel("道路坡度(°)")
        self.draw_a.set_title("车速-道路坡度")
        self.draw.canvas.show()

    # 效率
    def rbtn_efficiency(self):
        y = self._efficiency
        x = {}
        x[0] = self._VF1
        x[1] = self._VF2
        x[2] = self._VF3
        x[3] = self._VF4
        # 画图
        self.draw.clf()
        self.draw_a = self.draw.add_subplot(111)
        Colorx = ['r', 'b', 'g', 'k']
        Namex = ['1挡效率', '2挡效率', '3挡效率', '4挡效率']
        for i in range(4):
            self.draw_a.plot(x[i], y, color=Colorx[i], linewidth=3)
        self.draw_a.legend((Namex[0], Namex[1], Namex[2], Namex[3],), loc='upper left')  # 加一个逗号》》元组类型
        self.draw_a.set_xlabel("速度(m/s)")
        self.draw_a.set_ylabel("效率")
        self.draw_a.set_title("车速-效率")
        self.draw.canvas.show()

# 主程序
if __name__ == '__main__':
    root = tk.Tk()
    Login(root)
    root.resizable(False, False)
    root.mainloop()
