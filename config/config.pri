#
#  请不要直接使用此配置，应该使用VC-LTL helper for qmake.pri
#

# VC-LTL核心版本号，由于4.X并不兼容3.X。此值可以用于兼容性判断。
LTL_CoreVersion = 5

# 默认VC工具集版本
VisualStudioVersion = $$(VisualStudioVersion)

equals(VisualStudioVersion, 14.0) {
} else:equals(VisualStudioVersion, 15.0) {
} else:equals(VisualStudioVersion, 16.0) {
} else {
    error("VC-LTL: For Visual Studio 2015 , 2017 or 2019 only")
}


SUPPORTED_PLATFORM_LIST = x86 x64 arm arm64

LTLPlatform = $$(Platform)

isEmpty(LTLPlatform) {
    LTLPlatform = Win32
} else {
    !contains(SUPPORTED_PLATFORM_LIST, $$LTLPlatform) {
        error("VC-LTL: Unsupported platform: $$LTLPlatform")
    }
}

equals(LTLPlatform, x86) {
    LTLPlatform = Win32
}

# 环境变量选项
SupportWinXP_t = $$SupportWinXP
isEmpty(t){
    SupportWinXP_t = $$(SupportWinXP)
}

#匹配最佳 TargetPlatform
isEmpty(WindowsTargetPlatformMinVersion) {
    equals(LTLPlatform, arm64) {
        LTLWindowsTargetPlatformMinVersion = 10.0.10240.0
    } else:equals(LTLPlatform, arm) {
        LTLWindowsTargetPlatformMinVersion = 6.2.9200.0
    } else:!equals(SupportWinXP_t, true) {
        LTLWindowsTargetPlatformMinVersion = 6.0.6000.0
    } else:equals(LTLPlatform, x64) {
        LTLWindowsTargetPlatformMinVersion = 5.2.3790.0
    } else {
        LTLWindowsTargetPlatformMinVersion = 5.1.2600.0
    }
} else {
    LTLWindowsTargetPlatformMinVersionTmp = $$(WindowsTargetPlatformMinVersion)
    LTLWindowsTargetPlatformMinVersionTmp = $$split(LTLWindowsTargetPlatformMinVersionTmp, ".")
    LTLWindowsTargetPlatformMinVersionBuild = $$member(LTLWindowsTargetPlatformMinVersionTmp, 2)

    !lessThan(LTLWindowsTargetPlatformMinVersionBuild, 19041) {
        LTLWindowsTargetPlatformMinVersion = 10.0.19041.0
    } else:!lessThan(LTLWindowsTargetPlatformMinVersionBuild, 10240) {
        LTLWindowsTargetPlatformMinVersion = 10.0.10240.0
    } else:equals(LTLPlatform, arm64) {
        LTLWindowsTargetPlatformMinVersion = 10.0.10240.0
    } else:!lessThan(LTLWindowsTargetPlatformMinVersionBuild, 9200) {
        LTLWindowsTargetPlatformMinVersion = 6.2.9200.0
    } else:equals(LTLPlatform, arm) {
        LTLWindowsTargetPlatformMinVersion = 6.2.9200.0
    } else:!equals(SupportWinXP_t, true) {
        LTLWindowsTargetPlatformMinVersion = 6.0.6000.0
    } else:equals(LTLPlatform, x64) {
        LTLWindowsTargetPlatformMinVersion = 5.2.3790.0
    } else {
        LTLWindowsTargetPlatformMinVersion = 5.1.2600.0
    }
}



!exists($$VC_LTL_Root/TargetPlatform/$$LTLWindowsTargetPlatformMinVersion/lib/$$LTLPlatform) {
    error("VC-LTL: Cannot find lib files, please download latest pre-build packages from https://github.com/Chuyu-Team/VC-LTL/releases/latest")
}





# 搜索VC工具集版本
VCToolsVersion = $$(VCToolsVersion)



# 打印信息
VC_LTL_Info = \
$$escape_expand(\\n)**************************************** \
$$escape_expand(\\n)VC-LTL Path : $$VC_LTL_Root \
$$escape_expand(\\n)VC Tools Version : $$VCToolsVersion \
$$escape_expand(\\n)WindowsTargetPlatformMinVersion : $$LTLWindowsTargetPlatformMinVersion \
$$escape_expand(\\n)Platform : $$LTLPlatform \
$$escape_expand(\\n)****************************************

message($$VC_LTL_Info)


# 修改头文件及库搜索路径
QMAKE_INCDIR += \
	$$VC_LTL_Root/TargetPlatform/header \
    $$VC_LTL_Root/TargetPlatform/$$LTLWindowsTargetPlatformMinVersion/header

QMAKE_LIBS += \
    -L$$VC_LTL_Root/TargetPlatform/$$LTLWindowsTargetPlatformMinVersion/lib/$$LTLPlatform

