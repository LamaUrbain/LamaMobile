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
    WINRT_MANIFEST.name = "LamaUrbain"
    WINRT_MANIFEST.description = "L'application qui vous aide a trouver votre chemain comme un Lama !"
    WINRT_MANIFEST.publisher = "LamaUrbain"
    WINRT_MANIFEST.default_language = "fr"

    WINRT_MANIFEST.background = $${LITERAL_HASH}ED8642
    WINRT_MANIFEST.foreground = dark

    #WINRT_MANIFEST.logo_large = app-icons/AppIcon_150x150.png
    #WINRT_MANIFEST.logo_small = app-icons/AppIcon_30x30.png
    #WINRT_MANIFEST.logo_store = app-icons/AppIcon_50x50.png
    #WINRT_MANIFEST.logo_splash = app-icons/AppIcon_620x300.png
    #WINRT_MANIFEST.splash_screen =

    winphone:equals(WINSDK_VER, 8.1) {
        WINRT_MANIFEST.capabilities += internetClient
        WINRT_MANIFEST.capabilities_device += location
        #WINRT_MANIFEST.logo_medium = app-icons/AppIcon_100x100.png
        #WINRT_MANIFEST.tile_iconic_small = app-icons/AppIcon_71x110.png
        #WINRT_MANIFEST.tile_iconic_medium = app-icons/AppIcon_134x202.png
        #build_pass:FONTS = $$PWD/fonts/OpenSans-Bold.ttf $$PWD/fonts/OpenSans-Semibold.ttf $$PWD/fonts/OpenSans-Regular.ttf
    } else {
        WINRT_MANIFEST.capabilities += internetClient
    }

    CONFIG += windeployqt
    WINDEPLOYQT_OPTIONS = -no-svg -qmldir $$shell_quote($$system_path($$_PRO_FILE_PWD_))
}

export(INSTALLS)
