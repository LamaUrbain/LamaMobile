android-no-sdk {
    target.path = /data/user/qt
    export(target.path)
    INSTALLS += target
} else:android {
    x86 {
        target.path = /libs/x86
    } else: armeabi-v7a {
        target.path = /libs/armeabi-v7a
    } else {
        target.path = /libs/armeabi
    }
    export(target.path)
    INSTALLS += target
} else:unix {
    isEmpty(target.path) {
        qnx {
            target.path = /tmp/$${TARGET}/bin
        } else {
            target.path = /opt/$${TARGET}/bin
        }
        export(target.path)
    }
    INSTALLS += target
} else:winrt {
    #WINRT_MANIFEST.logo_large = app-icons/AppIcon_150x150.png
    #WINRT_MANIFEST.logo_small = app-icons/AppIcon_30x30.png
    #WINRT_MANIFEST.logo_store = app-icons/AppIcon_50x50.png
    #WINRT_MANIFEST.logo_splash = app-icons/AppIcon_620x300.png
    #WINRT_MANIFEST.background = $${LITERAL_HASH}00a2ff
    WINRT_MANIFEST.publisher = "LamaUrbain"
    winphone:equals(WINSDK_VER, 8.1) {
        WINRT_MANIFEST.capabilities += ID_CAP_NETWORKING
        WINRT_MANIFEST.capabilities += ID_CAP_LOCATION
        WINRT_MANIFEST.capabilities += ID_CAP_MAP
        #WINRT_MANIFEST.logo_medium = app-icons/AppIcon_100x100.png
        #WINRT_MANIFEST.tile_iconic_small = app-icons/AppIcon_71x110.png
        #WINRT_MANIFEST.tile_iconic_medium = app-icons/AppIcon_134x202.png
        #build_pass:FONTS = $$PWD/fonts/OpenSans-Bold.ttf $$PWD/fonts/OpenSans-Semibold.ttf $$PWD/fonts/OpenSans-Regular.ttf
    } else {
        WINRT_MANIFEST.capabilities += internetClient
    }
    #CONFIG += windeployqt
    #WINDEPLOYQT_OPTIONS = -no-svg -qmldir $$shell_quote($$system_path($$_PRO_FILE_PWD_))
}

export(INSTALLS)
