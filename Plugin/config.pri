CONFIG *= plugin 

TARGET_PATH=$$OUT_PWD/../..
#设置目标输出目录  
win32{
    CONFIG(debug, debug|release) {
        TARGET_PATH=$${TARGET_PATH}/Debug
    } else {
        TARGET_PATH=$${TARGET_PATH}/Release
    }
}
LIBS += -L$${TARGET_PATH}   #包含 RabbitIm 库位置  
!exists("$$OUT_PWD") : mkpath($$OUT_PWD)
#message("TARGET_PATH:$${TARGET_PATH}")

include($$PWD/../pri/ThirdLibraryConfig.pri)
myPackagesExist(RabbitIm){
    MYPKGCONFIG *= RabbitIm 
}else : msvc {
    LIBS += -lRabbitIm0
}
include($$PWD/../pri/ThirdLibrary.pri)
include($$PWD/../pri/ThirdLibraryJoin.pri)

#安装前缀  
isEmpty(PREFIX) {
    android {
       PREFIX = /.
    } else {
        PREFIX = $$OUT_PWD/../../install
    } 
}
contains(TEMPLATE, lib){

    CONFIG += create_prl link_prl #create_pc no_install_pc no_install_prl
    #QMAKE_PKGCONFIG_DESTDIR = ../pkgconfig

    #为静态插件生成必要的文件  
    CONFIG(static, static|shared) {
        isEmpty(RABBITIM_PLUG_NAME) : message("Please set RABBITIM_PLUG_NAME to plug class name")
        FILE_NAME=$$PWD/PluginStatic.cpp
        PLUG_CONTENT = "Q_IMPORT_PLUGIN($${RABBITIM_PLUG_NAME})"
        FILE_CONTENT = $$cat($$FILE_NAME)
        !contains(FILE_CONTENT, $$PLUG_CONTENT){
            PLUG_CONTENT = "    Q_IMPORT_PLUGIN($${RABBITIM_PLUG_NAME})"
            write_file($$FILE_NAME, PLUG_CONTENT, append)
        }
    
        FILE_NAME=$$PWD/PluginStatic.pri
        PLUG_CONTENT = "-l$${TARGET}"
        FILE_CONTENT = $$cat($$FILE_NAME) 
        !contains(FILE_CONTENT, $$PLUG_CONTENT){
            PLUG_CONTENT = "LIBS *= -L\$\${OUT_PWD}/plugins/App/$${TARGET} -l$${TARGET} "
            #PLUG_CONTENT += "myPackagesExist($${TARGET}) : MYPKGCONFIG *= $${TARGET}"
            write_file($$FILE_NAME, PLUG_CONTENT, append)
        }
    }

    #插件安装路径  
    DESTDIR = $$OUT_PWD/../../plugins/App/$${TARGET}
    mkpath($$DESTDIR)

    #翻译  
    include($$PWD/translations.pri)

    #插件安装路径  
    target.path = $$PREFIX/plugins/App/$${TARGET}
} else {
    target.path = $$PREFIX
    DESTDIR = $$TARGET_PATH
}

!android : INSTALLS += target