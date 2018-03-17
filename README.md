ReadMe for ICU 55.1        

**Note:** This is a draft readme.

DRAFT International Components for Unicode  
Release Candidate (Milestone Release) ICU 55.1 ReadMe
==================================================================================================

This is a development milestone release of ICU This milestone is intended for those wishing to get an early look at new features and API changes. It is not recommended for production use.

This is a release candidate version of ICU4C. It is not recommended for production use.

Last updated: 2015-Mar-25  
Copyright © 1997-2015 International Business Machines Corporation and others. All Rights Reserved.

* * *

Table of Contents
-----------------

*   [Introduction](#Introduction)
*   [Getting Started](#GettingStarted)
*   [What Is New In This release?](#News)
*   [How To Download the Source Code](#Download)
*   [ICU Source Code Organization](#SourceCode)
*   [How To Build And Install ICU](#HowToBuild)
    *   [Recommended Build Options](#RecBuild)
    *   [User-Configurable Settings](#UserConfig)
    *   [Windows](#HowToBuildWindows)
    *   [Cygwin](#HowToBuildCygwin)
    *   [UNIX](#HowToBuildUNIX)
    *   [z/OS (os/390)](#HowToBuildZOS)
    *   [IBM i family (IBM i, i5/OS, OS/400)](#HowToBuildOS400)
    *   [How to Cross Compile ICU](#HowToCrossCompileICU)
*   [How To Package ICU](#HowToPackage)
*   [Important Notes About Using ICU](#ImportantNotes)
    *   [Using ICU in a Multithreaded Environment](#ImportantNotesMultithreaded)
    *   [Windows Platform](#ImportantNotesWindows)
    *   [UNIX Type Platforms](#ImportantNotesUNIX)
*   [Platform Dependencies](#PlatformDependencies)
    *   [Porting To A New Platform](#PlatformDependenciesNew)
    *   [Platform Dependent Implementations](#PlatformDependenciesImpl)

* * *

[Introduction](#Introduction)
-----------------------------

Today's software market is a global one in which it is desirable to develop and maintain one application (single source/single binary) that supports a wide variety of languages. The International Components for Unicode (ICU) libraries provide robust and full-featured Unicode services on a wide variety of platforms to help this design goal. The ICU libraries provide support for:

*   The latest version of the Unicode standard
*   Character set conversions with support for over 220 codepages
*   Locale data for more than 300 locales
*   Language sensitive text collation (sorting) and searching based on the Unicode Collation Algorithm (=ISO 14651)
*   Regular expression matching and Unicode sets
*   Transformations for normalization, upper/lowercase, script transliterations (50+ pairs)
*   Resource bundles for storing and accessing localized information
*   Date/Number/Message formatting and parsing of culture specific input/output formats
*   Calendar specific date and time manipulation
*   Complex text layout for Arabic, Hebrew, Indic and Thai
*   Text boundary analysis for finding characters, word and sentence boundaries

ICU has a sister project ICU4J that extends the internationalization capabilities of Java to a level similar to ICU. The ICU C/C++ project is also called ICU4C when a distinction is necessary.

[Getting started](#GettingStarted)
----------------------------------

This document describes how to build and install ICU on your machine. For other information about ICU please see the following table of links.  
The ICU homepage also links to related information about writing internationalized software.

Here are some useful links regarding ICU and internationalization in general.

ICU, ICU4C & ICU4J Homepage

[http://icu-project.org/](http://icu-project.org/)

FAQ - Frequently Asked Questions about ICU

[http://userguide.icu-project.org/icufaq](http://userguide.icu-project.org/icufaq)

ICU User's Guide

[http://userguide.icu-project.org/](http://userguide.icu-project.org/)

How To Use ICU

[http://userguide.icu-project.org/howtouseicu](http://userguide.icu-project.org/howtouseicu)

Download ICU Releases

[http://site.icu-project.org/download](http://site.icu-project.org/download)

ICU4C API Documentation Online

[http://icu-project.org/apiref/icu4c/](http://icu-project.org/apiref/icu4c/)

Online ICU Demos

[http://demo.icu-project.org/icu-bin/icudemos](http://demo.icu-project.org/icu-bin/icudemos)

Contacts and Bug Reports/Feature Requests

[http://site.icu-project.org/contacts](http://site.icu-project.org/contacts)

**Important:** Please make sure you understand the [Copyright and License Information](license.html).

[What is new in this release?](#News)
-------------------------------------

### API Changes

See the [API Change Report](APIChangeReport.html) for a complete list of APIs added, removed, or changed in this release.

### Layout Engine: breaking API change

The LayoutEngine (already deprecated) has had the function LEFontInstance::getFontTable(LETag, size_t &length) since ICU 52. Its implementation was optional. In ICU 55, this version of getFontTable has been made pure virtual, and the version without a length (getFontTable(LETag)) has been completely removed. This is a breaking change for users who have not implemented the two-argument getFontTable() function in their LEFontInstance subclasses. The break is intentional, as the one-argument version cannot be made secure. See LEFontInstance api docs for more detail.

### Deprecations in PluralRules (plurrule.h)

The following PluralRules methods never had an implementation but were inadvertently marked @stable; they have now been deprecated. \[#[10759](http://bugs.icu-project.org/trac/ticket/10759)\]

*   double icu::PluralRules::getUniqueKeywordValue(const UnicodeString&)
*   int32\_t icu::PluralRules::getAllKeywordValues(const UnicodeString&, double*, int32\_t, UErrorCode&)

### Deprecate uidna.h functions for IDNA2003 support

The IDNA2003 API has been deprecated; use the API for IDNA2008 / UTS #46 instead via uidna_openUTS46() or class IDNA \[#[8477](http://bugs.icu-project.org/trac/ticket/v)\]. This applies to the following:

*   enum value UIDNA\_ALLOW\_UNASSIGNED
*   uidna_IDNToASCII
*   uidna_IDNToUnicode
*   uidna_compare
*   uidna_toASCII
*   uidna_toUnicode

### Deprecation (in ICU 54): Layout Engine

The LayoutEngine is now deprecated. Please see [the User's Guide](http://userguide.icu-project.org/layoutengine) for more details and migration recommendations. In the future, passing "--enable-layout" to configure will be required to enable the layout engine.

Note that the ParagraphLayout (layoutex) library is not deprecated. There is a new option, --enable-layoutex which will build the ParagraphLayout library using [HarfBuzz](http://harfbuzz.org) instead of ICU as the layout engine. See [the users' guide](http://userguide.icu-project.org/layoutengine) for more information about how to build.

### Deprecation (in ICU 54): Collation Short Strings

The collation short naming scheme and its API functions are deprecated. Use ucol_open() with language tag collation keywords instead (see [Collation API Details](http://userguide.icu-project.org/collation/api)). For example, `ucol_open("de-u-co-phonebk-ka-shifted", &errorCode)` for German Phonebook order with "ignore punctuation" mode.

### Deprecation (in ICU 54): UCOL\_TAILORINGS\_VERSION

This was originally intended to be the version of collation tailorings, but that information is actually in the tailorings data and this constant has always been (and now will continue to be) 1.

### Deprecation (in ICU 53): TimeUnitFormat

The TimeUnitFormat and its methods were actually deprecated in ICU 53 and the class as a whole was tagged as deprecated in that release, but the status tags for the individual methods did not correctly indicate the deprecated status; they do as of ICU 54. Use the MeasureFormat class and its methods instead.

### Full release notes and the latest updates

The previous list concentrates on _changes that affect existing applications migrating from previous ICU releases_. For more news about this release, as well as late-breaking news, see the [ICU download page](http://site.icu-project.org/download/54).

[How To Download the Source Code](#Download)
--------------------------------------------

There are two ways to download ICU releases:

*   **Official Release Snapshot:**  
    If you want to use ICU (as opposed to developing it), you should download an official packaged version of the ICU source code. These versions are tested more thoroughly than day-to-day development builds of the system, and they are packaged in zip and tar files for convenient download. These packaged files can be found at [http://site.icu-project.org/download](http://site.icu-project.org/download).  
    The packaged snapshots are named **icu-nnnn.zip** or **icu-nnnn.tgz**, where nnnn is the version number. The .zip file is used for Windows platforms, while the .tgz file is preferred on most other platforms.  
    Please unzip this file.
*   **Subversion Source Repository:**  
    If you are interested in developing features, patches, or bug fixes for ICU, you should probably be working with the latest version of the ICU source code. You will need to check the code out of our Subversion repository to ensure that you have the most recent version of all of the files. See our [source repository](http://site.icu-project.org/repository) for details.

[ICU Source Code Organization](#SourceCode)
-------------------------------------------

In the descriptions below, **_<ICU>_** is the full path name of the ICU directory (the top level directory from the distribution archives) in your file system. You can also view the [ICU Architectural Design](http://userguide.icu-project.org/design) section of the User's Guide to see which libraries you need for your software product. You need at least the data (`[lib]icudt`) and the common (`[lib]icuuc`) libraries in order to use ICU.

The following files describe the code drop.

File

Description

readme.html

Describes the International Components for Unicode (this file)

license.html

Contains the text of the ICU license

  

The following directories contain source code and data files.

Directory

Description

_<ICU>_/source/**common**/

The core Unicode and support functionality, such as resource bundles, character properties, locales, codepage conversion, normalization, Unicode properties, Locale, and UnicodeString.

_<ICU>_/source/**i18n**/

Modules in i18n are generally the more data-driven, that is to say resource bundle driven, components. These deal with higher-level internationalization issues such as formatting, collation, text break analysis, and transliteration.

_<ICU>_/source/**layout**/

Contains the ICU complex text layout engine. (Deprecated)

_<ICU>_/source/**layoutex**/

Contains the ICU paragraph layout engine.

_<ICU>_/source/**io**/

Contains the ICU I/O library.

_<ICU>_/source/**data**/

This directory contains the source data in text format, which is compiled into binary form during the ICU build process. It contains several subdirectories, in which the data files are grouped by function. Note that the build process must be run again after any changes are made to this directory.

If some of the following directories are missing, it's probably because you got an official download. If you need the data source files for customization, then please download the ICU source code from [subversion](http://site.icu-project.org/repository).

*   **in/** A directory that contains a pre-built data library for ICU. A standard source code package will contain this file without several of the following directories. This is to simplify the build process for the majority of users and to reduce platform porting issues.
*   **brkitr/** Data files for character, word, sentence, title casing and line boundary analysis.
*   **locales/** These .txt files contain ICU language and culture-specific localization data. Two special bundles are **root**, which is the fallback data and parent of other bundles, and **index**, which contains a list of installed bundles. The makefile **resfiles.mk** contains the list of resource bundle files.
*   **mappings/** Here are the code page converter tables. These .ucm files contain mappings to and from Unicode. These are compiled into .cnv files. **convrtrs.txt** is the alias mapping table from various converter name formats to ICU internal format and vice versa. It produces cnvalias.icu. The makefiles **ucmfiles.mk, ucmcore.mk,** and **ucmebcdic.mk** contain the list of converters to be built.
*   **translit/** This directory contains transliterator rules as resource bundles, a makefile **trnsfiles.mk** containing the list of installed system translitaration files, and as well the special bundle **translit_index** which lists the system transliterator aliases.
*   **unidata/** This directory contains the Unicode data files. Please see [http://www.unicode.org/](http://www.unicode.org/) for more information.
*   **misc/** The misc directory contains other data files which did not fit into the above categories. Currently it only contains time zone information, and a name preperation file for [IDNA](http://www.ietf.org/rfc/rfc3490.txt).
*   **out/** This directory contains the assembled memory mapped files.
*   **out/build/** This directory contains intermediate (compiled) files, such as .cnv, .res, etc.

If you are creating a special ICU build, you can set the ICU_DATA environment variable to the out/ or the out/build/ directories, but this is generally discouraged because most people set it incorrectly. You can view the [ICU Data Management](http://userguide.icu-project.org/icudata) section of the ICU User's Guide for details.

_<ICU>_/source/test/**intltest**/

A test suite including all C++ APIs. For information about running the test suite, see the build instructions specific to your platform later in this document.

_<ICU>_/source/test/**cintltst**/

A test suite written in C, including all C APIs. For information about running the test suite, see the build instructions specific to your platform later in this document.

_<ICU>_/source/test/**iotest**/

A test suite written in C and C++ to test the icuio library. For information about running the test suite, see the build instructions specific to your platform later in this document.

_<ICU>_/source/test/**testdata**/

Source text files for data, which are read by the tests. It contains the subdirectories **out/build/** which is used for intermediate files, and **out/** which contains **testdata.dat.**

_<ICU>_/source/**tools**/

Tools for generating the data files. Data files are generated by invoking _<ICU>_/source/data/build/makedata.bat on Win32 or _<ICU>_/source/make on UNIX.

_<ICU>_/source/**samples**/

Various sample programs that use ICU

_<ICU>_/source/**extra**/

Non-supported API additions. Currently, it contains the 'uconv' tool to perform codepage conversion on files.

_<ICU>_/**packaging**/

This directory contain scripts and tools for packaging the final ICU build for various release platforms.

_<ICU>_/source/**config**/

Contains helper makefiles for platform specific build commands. Used by 'configure'.

_<ICU>_/source/**allinone**/

Contains top-level ICU workspace and project files, for instance to build all of ICU under one MSVC project.

_<ICU>_/**include**/

Contains the headers needed for developing software that uses ICU on Windows.

_<ICU>_/**lib**/

Contains the import libraries for linking ICU into your Windows application.

_<ICU>_/**bin**/

Contains the libraries and executables for using ICU on Windows.

[How To Build And Install ICU](#HowToBuild)
-------------------------------------------

### [Recommended Build Options](#RecBuild)

Depending on the platform and the type of installation, we recommend a small number of modifications and build options. Note that C99 compatibility is now required.

*   **Namespace:** By default, unicode/uversion.h has "using namespace icu;" which defeats much of the purpose of the namespace. (This is for historical reasons: Originally, ICU4C did not use namespaces, and some compilers did not support them. The default "using" statement preserves source code compatibility.)  
    If this compatibility is not an issue, we recommend you turn this off via `-DU_USING_ICU_NAMESPACE=0` or by modifying unicode/uversion.h:
    
    Index: source/common/unicode/uversion.h
    ===================================================================
    \-\-\- source/common/unicode/uversion.h    (revision 26606)
    \+\+\+ source/common/unicode/uversion.h    (working copy)
    @@ -180,7 +180,8 @@
     #   define U\_NAMESPACE\_QUALIFIER U\_ICU\_NAMESPACE::
    
     #   ifndef U\_USING\_ICU_NAMESPACE
    -#       define U\_USING\_ICU_NAMESPACE 1
    \+        // Set to 0 to force namespace declarations in ICU usage.
    +#       define U\_USING\_ICU_NAMESPACE 0
     #   endif
     #   if U\_USING\_ICU_NAMESPACE
             U\_NAMESPACE\_USE
    
    ICU call sites then either qualify ICU types explicitly, for example `icu::UnicodeString`, or do `using icu::UnicodeString;` where appropriate.
*   **Hardcode the default charset to UTF-8:** On platforms where the default charset is always UTF-8, like MacOS X and some Linux distributions, we recommend hardcoding ICU's default charset to UTF-8. This means that some implementation code becomes simpler and faster, and statically linked ICU libraries become smaller. (See the [U\_CHARSET\_IS_UTF8](http://icu-project.org/apiref/icu4c/utypes_8h.html#0a33e1edf3cd23d9e9c972b63c9f7943) API documentation for more details.)  
    You can `-DU_CHARSET_IS_UTF8=1` or modify unicode/utypes.h (in ICU 4.8 and below) or modify unicode/platform.h (in ICU 49 and higher):
    
    Index: source/common/unicode/utypes.h
    ===================================================================
    \-\-\- source/common/unicode/utypes.h      (revision 26606)
    \+\+\+ source/common/unicode/utypes.h      (working copy)
    @@ -160,7 +160,7 @@
      \* @see UCONFIG\_NO\_CONVERSION
      */
     #ifndef U\_CHARSET\_IS_UTF8
    -#   define U\_CHARSET\_IS_UTF8 0
    +#   define U\_CHARSET\_IS_UTF8 1
     #endif
    
     /*===========================================================================*/
    
*   **UnicodeString constructors:** The UnicodeString class has several single-argument constructors that are not marked "explicit" for historical reasons. This can lead to inadvertent construction of a `UnicodeString` with a single character by using an integer, and it can lead to inadvertent dependency on the conversion framework by using a C string literal.  
    Beginning with ICU 49, you should do the following:
    *   Consider marking the from-`UChar` and from-`UChar32` constructors explicit via `-DUNISTR_FROM_CHAR_EXPLICIT=explicit` or similar.
    *   Consider marking the from-`const char*` and from-`const UChar*` constructors explicit via `-DUNISTR_FROM_STRING_EXPLICIT=explicit` or similar.Note: The ICU test suites cannot be compiled with these settings.
*   **utf.h, utf8.h, utf16.h, utf_old.h:** By default, utypes.h (and thus almost every public ICU header) includes all of these header files. Often, none of them are needed, or only one or two of them. All of utf_old.h is deprecated or obsolete.  
    Beginning with ICU 49, you should define `U_NO_DEFAULT_INCLUDE_UTF_HEADERS` to 1 (via -D or uconfig.h, as above) and include those header files explicitly that you actually need.  
    Note: The ICU test suites cannot be compiled with this setting.
*   **.dat file:** By default, the ICU data is built into a shared library (DLL). This is convenient because it requires no install-time or runtime configuration, but the library is platform-specific and cannot be modified. A .dat package file makes the opposite trade-off: Platform-portable (except for endianness and charset family, which can be changed with the icupkg tool) and modifiable (also with the icupkg tool). If a path is set, then single data files (e.g., .res files) can be copied to that location to provide new locale data or conversion tables etc.  
    The only drawback with a .dat package file is that the application needs to provide ICU with the file system path to the package file (e.g., by calling `u_setDataDirectory()`) or with a pointer to the data (`udata_setCommonData()`) before other ICU API calls. This is usually easy if ICU is used from an application where `main()` takes care of such initialization. It may be hard if ICU is shipped with another shared library (such as the Xerces-C++ XML parser) which does not control `main()`.  
    See the [User Guide ICU Data](http://userguide.icu-project.org/icudata) chapter for more details.  
    If possible, we recommend building the .dat package. Specify `--with-data-packaging=archive` on the configure command line, as in  
    `runConfigureICU Linux --with-data-packaging=archive`  
    (Read the configure script's output for further instructions. On Windows, the Visual Studio build generates both the .dat package and the data DLL.)  
    Be sure to install and use the tiny stubdata library rather than the large data DLL.
*   **Static libraries:** It may make sense to build the ICU code into static libraries (.a) rather than shared libraries (.so/.dll). Static linking reduces the overall size of the binary by removing code that is never called.  
    Example configure command line:  
    `runConfigureICU Linux --enable-static --disable-shared`
*   **Out-of-source build:** It is usually desirable to keep the ICU source file tree clean and have build output files written to a different location. This is called an "out-of-source build". Simply invoke the configure script from the target location:
    
    ~/icu$ svn export http://source.icu-project.org/repos/icu/icu/trunk
    ~/icu$ mkdir trunk-dev
    ~/icu$ cd trunk-dev
    ~/icu/trunk-dev$ ../trunk/source/runConfigureICU Linux
    ~/icu/trunk-dev$ make check
    
      
    (Note: this example shows a relative path to `runConfigureICU`. If you experience difficulty, try using an absolute path to `runConfigureICU` instead.)

#### ICU as a System-Level Library

If ICU is installed as a system-level library, there are further opportunities and restrictions to consider. For details, see the _Using ICU as an Operating System Level Library_ section of the [User Guide ICU Architectural Design](http://userguide.icu-project.org/design) chapter.

*   **Data path:** For a system-level library, it is best to load ICU data from the .dat package file because the file system path to the .dat package file can be hardcoded. ICU will automatically set the path to the final install location using U\_ICU\_DATA\_DEFAULT\_DIR. Alternatively, you can set `-DICU_DATA_DIR=/path/to/icu/data` when building the ICU code. (Used by source/common/putil.c.)  
    Consider also setting `-DICU_NO_USER_DATA_OVERRIDE` if you do not want the "ICU_DATA" environment variable to be used. (An application can still override the data path via `u_setDataDirectory()` or `udata_setCommonData()`.
*   **Hide draft API:** API marked with `@draft` is new and not yet stable. Applications must not rely on unstable APIs from a system-level library. Define `U_HIDE_DRAFT_API`, `U_HIDE_INTERNAL_API` and `U_HIDE_SYSTEM_API` by modifying unicode/utypes.h before installing it.
*   **Only C APIs:** Applications must not rely on C++ APIs from a system-level library because binary C++ compatibility across library and compiler versions is very hard to achieve. Most ICU C++ APIs are in header files that contain a comment with `\brief C++ API`. Consider not installing these header files.
*   **Disable renaming:** By default, ICU library entry point names have an ICU version suffix. Turn this off for a system-level installation, to enable upgrading ICU without breaking applications. For example:  
    `runConfigureICU Linux --disable-renaming`  
    The public header files from this configuration must be installed for applications to include and get the correct entry point names.

### [User-Configurable Settings](#UserConfig)

ICU4C can be customized via a number of user-configurable settings. Many of them are controlled by preprocessor macros which are defined in the `source/common/unicode/uconfig.h` header file. Some turn off parts of ICU, for example conversion or collation, trading off a smaller library for reduced functionality. Other settings are recommended (see previous section) but their default values are set for better source code compatibility.

In order to change such user-configurable settings, you can either modify the `uconfig.h` header file by adding a specific `#define ...` for one or more of the macros before they are first tested, or set the compiler's preprocessor flags (`CPPFLAGS`) to include an equivalent `-D` macro definition.

### [How To Build And Install On Windows](#HowToBuildWindows)

Building International Components for Unicode requires:

*   Microsoft Windows
*   Microsoft Visual C++ (see the ICU download page for the currently compatible version)

[Cygwin](#HowToBuildCygwin) is required if using a version of MSVC other than the one compatible with the supplied project files or if other compilers are used to build ICU. (e.g. GCC)

The steps are:

1.  Unzip the icu-XXXX.zip file into any convenient location. Using command line zip, type "unzip -a icu-XXXX.zip -d drive:\\directory", or just use WinZip.
2.  Be sure that the ICU binary directory, _<ICU>_\\bin\\, is included in the **PATH** environment variable. The tests will not work without the location of the ICU DLL files in the path.
3.  Open the "_<ICU>_\\source\\allinone\\allinone.sln" workspace file in Microsoft Visual Studio. (This solution includes all the International Components for Unicode libraries, necessary ICU building tools, and the test suite projects). Please see the [command line note below](#HowToBuildWindowsCommandLine) if you want to build from the command line instead.
4.  Set the active platform to "Win32" or "x64" (See [Windows platform note](#HowToBuildWindowsPlatform) below) and configuration to "Debug" or "Release" (See [Windows configuration note](#HowToBuildWindowsConfig) below).
5.  Choose the "Build" menu and select "Rebuild Solution". If you want to build the Debug and Release at the same time, see the [batch configuration note](#HowToBuildWindowsBatch) below.
6.  Run the tests. They can be run from the command line or from within Visual Studio.
    
    #### Running the Tests from the Windows Command Line (cmd)
    
    *   For x86 (32 bit) and Debug, use:  
        _<ICU>_\\source\\allinone\\icucheck.bat _Platform_ _Configuration_  
        
    *   So, for example:  
        _<ICU>_\\source\\allinone\\icucheck.bat **x86** **Debug** or _<ICU>_\\source\\allinone\\icucheck.bat **x86** **Release** or _<ICU>_\\source\\allinone\\icucheck.bat **x64** **Release**
    
    #### Running the Tests from within Visual Studio
    
    1.  Run the C++ test suite, "intltest". To do this: set the active startup project to "intltest", and press Ctrl+F5 to run it. Make sure that it passes without any errors.
    2.  Run the C test suite, "cintltst". To do this: set the active startup project to "cintltst", and press Ctrl+F5 to run it. Make sure that it passes without any errors.
    3.  Run the I/O test suite, "iotest". To do this: set the active startup project to "iotest", and press Ctrl+F5 to run it. Make sure that it passes without any errors.
7.  You are now able to develop applications with ICU by using the libraries and tools in _<ICU>_\\bin\\. The headers are in _<ICU>_\\include\ and the link libraries are in _<ICU>_\\lib\\. To install the ICU runtime on a machine, or ship it with your application, copy the needed components from _<ICU>_\\bin\ to a location on the system PATH or to your application directory.

**Using MSDEV At The Command Line Note:** You can build ICU from the command line. Assuming that you have properly installed Microsoft Visual C++ to support command line execution, you can run the following command, 'devenv.com _<ICU>_\\source\\allinone\\allinone.sln /build "Win32|Release"'. You can also use Cygwin with this compiler to build ICU, and you can refer to the [How To Build And Install On Windows with Cygwin](#HowToBuildCygwin) section for more details.

**Setting Active Platform Note:** Even though you are able to select "x64" as the active platform, if your operating system is not a 64 bit version of Windows, the build will fail. To set the active platform, two different possibilities are:

*   Choose "Build" menu, select "Configuration Manager...", and select "Win32" or "x64" for the Active Platform Solution.
*   Another way is to select the desired build configuration from "Solution Platforms" dropdown menu from the standard toolbar. It will say "Win32" or "x64" in the dropdown list.

**Setting Active Configuration Note:** To set the active configuration, two different possibilities are:

*   Choose "Build" menu, select "Configuration Manager...", and select "Release" or "Debug" for the Active Configuration Solution.
*   Another way is to select the desired build configuration from "Solution Configurations" dropdown menu from the standard toolbar. It will say "Release" or "Debug" in the dropdown list.

**Batch Configuration Note:** If you want to build the Win32 and x64 platforms and Debug and Release configurations at the same time, choose "Build" menu, and select "Batch Build...". Click the "Select All" button, and then click the "Rebuild" button.

### [How To Build And Install On Windows with Cygwin](#HowToBuildCygwin)

Building International Components for Unicode with this configuration requires:

*   Microsoft Windows
*   Microsoft Visual C++ (when gcc isn't used).
*   Cygwin with the following installed:
    *   bash
    *   GNU make
    *   ar
    *   ranlib
    *   man (if you plan to look at the man pages)

There are two ways you can build ICU with Cygwin. You can build with gcc or Microsoft Visual C++. If you use gcc, the resulting libraries and tools will depend on the Cygwin environment. If you use Microsoft Visual C++, the resulting libraries and tools do not depend on Cygwin and can be more easily distributed to other Windows computers (the generated man pages and shell scripts still need Cygwin). To build with gcc, please follow the "[How To Build And Install On UNIX](#HowToBuildUNIX)" instructions, while you are inside a Cygwin bash shell. To build with Microsoft Visual C++, please use the following instructions:

1.  Start the Windows "Command Prompt" window. This is different from the gcc build, which requires the Cygwin Bash command prompt. The Microsoft Visual C++ compiler will not work with a bash command prompt.
2.  If the computer isn't set up to use Visual C++ from the command line, you need to run vcvars32.bat.  
    For example:  
    "C:\\Program Files\\Microsoft Visual Studio 8\\VC\\bin\\vcvars32.bat" can be used for 32-bit builds **or**  
    "C:\\Program Files (x86)\\Microsoft Visual Studio 8\\VC\\bin\\amd64\\vcvarsamd64.bat" can be used for 64-bit builds on Windows x64.
3.  Unzip the icu-XXXX.zip file into any convenient location. Using command line zip, type "unzip -a icu-XXXX.zip -d drive:\\directory", or just use WinZip.
4.  Change directory to "icu/source", which is where you unzipped ICU.
5.  Run "bash [./runConfigureICU](source/runConfigureICU) Cygwin/MSVC" (See [Windows configuration note](#HowToWindowsConfigureICU) and non-functional configure options below).
6.  Type "make" to compile the libraries and all the data files. This make command should be GNU make.
7.  Optionally, type "make check" to run the test suite, which checks for ICU's functionality integrity (See [testing note](#HowToTestWithoutGmake) below).
8.  Type "make install" to install ICU. If you used the --prefix= option on configure or runConfigureICU, ICU will be installed to the directory you specified. (See [installation note](#HowToInstallICU) below).

**Configuring ICU on Windows NOTE:**

Ensure that the order of the PATH is MSVC, Cygwin, and then other PATHs. The configure script needs certain tools in Cygwin (e.g. grep).

Also, you may need to run "dos2unix.exe" on all of the scripts (e.g. configure) in the top source directory of ICU. To avoid this issue, you can download the ICU source for Unix platforms (icu-xxx.tgz).

In addition to the Unix [configuration note](#HowToConfigureICU) the following configure options currently do not work on Windows with Microsoft's compiler. Some options can work by manually editing icu/source/common/unicode/pwin32.h, but manually editing the files is not recommended.

*   --disable-renaming
*   --enable-tracing
*   --enable-rpath
*   --enable-static (Requires that U\_STATIC\_IMPLEMENTATION be defined in user code that links against ICU's static libraries.)
*   --with-data-packaging=files (The pkgdata tool currently does not work in this mode. Manual packaging is required to use this mode.)

### [How To Build And Install On UNIX](#HowToBuildUNIX)

Building International Components for Unicode on UNIX requires:

*   A C++ compiler installed on the target machine (for example: gcc, CC, xlC_r, aCC, cxx, etc...).
*   An ANSI C compiler installed on the target machine (for example: cc).
*   A recent version of GNU make (3.80+).
*   For a list of z/OS tools please view the [z/OS build section](#HowToBuildZOS) of this document for further details.

Here are the steps to build ICU:

1.  Decompress the icu-_X_._Y_.tgz (or icu-_X_._Y_.tar.gz) file. For example, gunzip -d < icu-_X_._Y_.tgz | tar xvf -
2.  Change directory to `icu/source`. cd icu/source
3.  Some files may have the wrong permissions.chmod +x runConfigureICU configure install-sh
4.  Run the [runConfigureICU](source/runConfigureICU) script for your platform. (See [configuration note](#HowToConfigureICU) below).
5.  Now build: gmake (or just `make` if GNU make is the default make on your platform) to compile the libraries and all the data files. The proper name of the GNU make command is printed at the end of the configuration run, as in "You must use gmake to compile ICU".  
    Note that the compilation command output may be simplified on your platform. If this is the case, you will see just: gcc ... stubdata.c rather than gcc -DU\_NO\_DEFAULT\_INCLUDE\_UTF\_HEADERS=1 -D\_REENTRANT -I../common -DU\_ATTRIBUTE\_DEPRECATED= -O2 -Wall -std=c99 -pedantic -Wshadow -Wpointer-arith -Wmissing-prototypes -Wwrite-strings -c -DPIC -fPIC -o stubdata.o stubdata.c  
    If you need to see the whole compilation line, use "gmake VERBOSE=1". The full compilation line will print if an error occurs.
6.  Optionally,gmake check will run the test suite, which checks for ICU's functionality integrity (See [testing note](#HowToTestWithoutGmake) below).
7.  To install, gmake install to install ICU. If you used the --prefix= option on configure or runConfigureICU, ICU will be installed to the directory you specified. (See [installation note](#HowToInstallICU) below).

**Configuring ICU NOTE:** Type "./runConfigureICU --help" for help on how to run it and a list of supported platforms. You may also want to type "./configure --help" to print the available configure options that you may want to give runConfigureICU. If you are not using the runConfigureICU script, or your platform is not supported by the script, you may need to set your CC, CXX, CFLAGS and CXXFLAGS environment variables, and type "./configure". HP-UX users, please see this [note regarding HP-UX multithreaded build issues](#ImportantNotesHPUX) with newer compilers. Solaris users, please see this [note regarding Solaris multithreaded build issues](#ImportantNotesSolaris).

ICU is built with strict compiler warnings enabled by default. If this causes excessive numbers of warnings on your platform, use the --disable-strict option to configure to reduce the warning level.

**Running The Tests From The Command Line NOTE:** You may have to set certain variables if you with to run test programs individually, that is apart from "gmake check". The environment variable **ICU_DATA** can be set to the full pathname of the data directory to indicate where the locale data files and conversion mapping tables are when you are not using the shared library (e.g. by using the .dat archive or the individual data files). The trailing "/" is required after the directory name (e.g. "$Root/source/data/out/" will work, but the value "$Root/source/data/out" is not acceptable). You do not need to set **ICU_DATA** if the complete shared data library is in your library path.

**Installing ICU NOTE:** Some platforms use package management tools to control the installation and uninstallation of files on the system, as well as the integrity of the system configuration. You may want to check if ICU can be packaged for your package management tools by looking into the "packaging" directory. (Please note that if you are using a snapshot of ICU from Subversion, it is probable that the packaging scripts or related files are not up to date with the contents of ICU at this time, so use them with caution).

### [How To Build And Install On z/OS (OS/390)](#HowToBuildZOS)

You can install ICU on z/OS or OS/390 (the previous name of z/OS), but IBM tests only the z/OS installation. You install ICU in a z/OS UNIX system services file system such as HFS or zFS. On this platform, it is important that you understand a few details:

*   The makedep and GNU make tools are required for building ICU. If it is not already installed on your system, it is available at the [z/OS UNIX - Tools and Toys](http://www-03.ibm.com/servers/eserver/zseries/zos/unix/bpxa1toy.html) site. The PATH environment variable should be updated to contain the location of this executable prior to build. Failure to add these tools to your PATH will cause ICU build failures or cause pkgdata to fail to run.
*   Since USS does not support using the mmap() function over NFS, it is recommended that you build ICU on a local filesystem. Once ICU has been built, you should not have this problem while using ICU when the data library has been built as a shared library, which is this is the default setting.
*   Encoding considerations: The source code assumes that it is compiled with codepage ibm-1047 (to be exact, the UNIX System Services variant of it). The pax command converts all of the source code files from ASCII to codepage ibm-1047 (USS) EBCDIC. However, some files are binary files and must not be converted, or must be converted back to their original state. You can use the [unpax-icu.sh](as_is/os390/unpax-icu.sh) script to do this for you automatically. It will unpackage the tar file and convert all the necessary files for you automatically.
*   z/OS supports both native S/390 hexadecimal floating point and (with OS/390 2.6 and later) IEEE 754 binary floating point. This is a compile time option. Applications built with IEEE should use ICU DLLs that are built with IEEE (and vice versa). The environment variable IEEE390=0 will cause the z/OS version of ICU to be built without IEEE floating point support and use the native hexadecimal floating point. By default ICU is built with IEEE 754 support. Native floating point support is sufficient for codepage conversion, resource bundle and UnicodeString operations, but the Format APIs require IEEE binary floating point.
*   z/OS introduced the concept of Extra Performance Linkage (XPLINK) to bring performance improvement opportunities to call-intensive C and C++ applications such as ICU. XPLINK is enabled on a DLL-by-DLL basis, so if you are considering using XPLINK in your application that uses ICU, you should consider building the XPLINK-enabled version of ICU. You need to set ICU's environment variable `OS390_XPLINK=1` prior to invoking the make process to produce binaries that are enabled for XPLINK. The XPLINK option, which is available for z/OS 1.2 and later, requires the PTF PQ69418 to build XPLINK enabled binaries.
*   ICU requires XPLINK for the icuio library. If you want to use the rest of ICU without XPLINK, then you must use the --disable-icuio configure option.
*   The latest versions of z/OS use [XPLINK version (C128) of the C++ standard library](http://www.ibm.com/support/docview.wss?uid=swg2120240) by default. You may see [an error](http://www.ibm.com/support/docview.wss?uid=swg21376279) when running with XPLINK disabled. To avoid this error, set the following environment variable or similar:
    
    export \_CXX\_PSYSIX="CEE.SCEELIB(C128N)":"CBC.SCLBSID(IOSTREAM,COMPLEX)"
    
*   When building ICU data, the heap size may need to be increased with the following environment variable:
    
    export \_CEE\_RUNOPTS="HEAPPOOLS(ON),HEAP(4M,1M,ANY,FREE,0K,4080)"
    
*   The rest of the instructions for building and testing ICU on z/OS with UNIX System Services are the same as the [How To Build And Install On UNIX](#HowToBuildUNIX) section.

#### z/OS (Batch/PDS) support outside the UNIX system services environment

By default, ICU builds its libraries into the UNIX file system (HFS). In addition, there is a z/OS specific environment variable (OS390BATCH) to build some libraries into the z/OS native file system. This is useful, for example, when your application is externalized via Job Control Language (JCL).

The OS390BATCH environment variable enables non-UNIX support including the batch environment. When OS390BATCH is set, the libicui18n_XX_.dll, libicuuc_XX_.dll, and libicudt_XX_e.dll binaries are built into data sets (the native file system). Turning on OS390BATCH does not turn off the normal z/OS UNIX build. This means that the z/OS UNIX (HFS) DLLs will always be created.

Two additional environment variables indicate the names of the z/OS data sets to use. The LOADMOD environment variable identifies the name of the data set that contains the dynamic link libraries (DLLs) and the LOADEXP environment variable identifies the name of the data set that contains the side decks, which are normally the files with the .x suffix in the UNIX file system.

A data set is roughly equivalent to a UNIX or Windows file. For most kinds of data sets the operating system maintains record boundaries. UNIX and Windows files are byte streams. Two kinds of data sets are PDS and PDSE. Each data set of these two types contains a directory. It is like a UNIX directory. Each "file" is called a "member". Each member name is limited to eight bytes, normally EBCDIC.

Here is an example of some environment variables that you can set prior to building ICU:

OS390BATCH=1
LOADMOD=_USER_.ICU.LOAD
LOADEXP=_USER_.ICU.EXP

The PDS member names for the DLL file names are as follows:

IXMI_XX_IN --> libicui18n_XX_.dll
IXMI_XX_UC --> libicuuc_XX_.dll
IXMI_XX_DA --> libicudt_XX_e.dll

You should point the LOADMOD environment variable at a partitioned data set extended (PDSE) and point the LOADEXP environment variable at a partitioned data set (PDS). The PDSE can be allocated with the following attributes:

Data Set Name . . . : _USER_.ICU.LOAD
Management class. . : _\*\*None\*\*_
Storage class . . . : _BASE_
Volume serial . . . : _TSO007_
Device type . . . . : _3390_
Data class. . . . . : _LOAD_
Organization  . . . : PO
Record format . . . : U
Record length . . . : 0
Block size  . . . . : _32760_
1st extent cylinders: 1
Secondary cylinders : 5
Data set name type  : LIBRARY

The PDS can be allocated with the following attributes:

Data Set Name . . . : _USER_.ICU.EXP
Management class. . : _\*\*None\*\*_
Storage class . . . : _BASE_
Volume serial . . . : _TSO007_
Device type . . . . : _3390_
Data class. . . . . : _\*\*None\*\*_
Organization  . . . : PO
Record format . . . : FB
Record length . . . : 80
Block size  . . . . : _3200_
1st extent cylinders: 3
Secondary cylinders : 3
Data set name type  : PDS

### [How To Build And Install On The IBM i Family (IBM i, i5/OS OS/400)](#HowToBuildOS400)

Before you start building ICU, ICU requires the following:

*   QSHELL interpreter installed (install base option 30, operating system)
*   ILE C/C++ Compiler installed on the system
*   The latest IBM tools for Developers for IBM i — [http://www.ibm.com/servers/enable/site/porting/tools/](http://www.ibm.com/servers/enable/site/porting/tools/)

The following describes how to setup and build ICU. For background information, you should look at the [UNIX build instructions](#HowToBuildUNIX).

1.  Copy the ICU source .tgz to the IBM i environment, as binary. Also, copy the [unpax-icu.sh](as_is/os400/unpax-icu.sh) script into the same directory, as a text file.
2.  Create target library. This library will be the target for the resulting modules, programs and service programs. You will specify this library on the OUTPUTDIR environment variable.
    
    CRTLIB LIB(_libraryname_)
    ADDENVVAR ENVVAR(OUTPUTDIR) VALUE('_libraryname_') REPLACE(*YES) 
    
3.  Set up the following environment variables and job characteristics in your build process
    
    ADDENVVAR ENVVAR(MAKE) VALUE('gmake') REPLACE(*YES)
    CHGJOB CCSID(37)
    
4.  Fire up the QSH _(all subsequent commands are run inside the qsh session.)_
    
    qsh
    
5.  Set up the PATH:
    
    export PATH=/QIBM/ProdData/DeveloperTools/qsh/bin:$PATH:/QOpenSys/usr/bin
    
6.  Unpack the ICU source code archive:
    
    gzip -d icu-_X_._Y_.tgz
    
7.  Run unpax-icu.sh on the tar file generated from the previous step.
    
    unpax-icu.sh icu.tar
    
8.  Build the program ICULD which ICU will use for linkage.
    
    cd icu/as_is/os400
    qsh bldiculd.sh
    cd ../../..
    
9.  Change into the 'source' directory, and configure ICU. (See [configuration note](#HowToConfigureICU) for details). Note that --with-data-packaging=archive and setting the --prefix are recommended, building in default (dll) mode is currently not supported.
    
    cd icu/source
    ./runConfigureICU IBMi --prefix=_/path/to/somewhere_ --with-data-packaging=archive
    
10.  Build ICU. _(Note: Do not use the -j option)_
    
    gmake
    
11.  Test ICU.
    
    gmake check
    
    (The QIBM\_MULTI\_THREADED=Y flag will be automatically applied to intltest - you can look at the [iSeries Information Center](http://publib.boulder.ibm.com/infocenter/iseries/v5r3/index.jsp?topic=/apis/concept4.htm) for more details regarding the running of multiple threads on IBM i.)

### [How To Cross Compile ICU](#HowToCrossCompileICU)

This section will explain how to build ICU on one platform, but to produce binaries intended to run on another. This is commonly known as a cross compile.

Normally, in the course of a build, ICU needs to run the tools that it builds in order to generate and package data and test-data.In a cross compilation setting, ICU is built on a different system from that which it eventually runs on. An example might be, if you are building for a small/headless system (such as an embedded device), or a system where you can't easily run the ICU command line tools (any non-UNIX-like system).

To reduce confusion, we will here refer to the "A" and the "B" system.System "A" is the actual system we will be running on- the only requirements on it is are it is able to build ICU from the command line targetting itself (with configure or runConfigureICU), and secondly, that it also contain the correct toolchain for compiling and linking for the resultant platform, referred to as the "B" system.

The autoconf docs use the term "build" for A, and "host" for B. More details at: [http://www.gnu.org/software/autoconf/manual/html_node/Specifying-Names.html](http://www.gnu.org/software/autoconf/manual/html_node/Specifying-Names.html#Specifying-Names)

Three initially-empty directories will be used in this example:

/icu

a copy of the ICU source

/buildA

an empty directory, it will contain ICU built for A  
(MacOSX in this case)

/buildB

an empty directory, it will contain ICU built for B  
(HaikuOS in this case)

1.  Check out or unpack the ICU source code into the /icu directory.You will have the directories /icu/source, etc.
2.  Build ICU in /buildA normally (using runConfigureICU or configure):
    
    cd /buildA
    sh /icu/source/runConfigureICU **MacOSX**
    gnumake
    
3.  Set PATH or other variables as needed, such as CPPFLAGS.
4.  Build ICU in /buildB  
    
    "`--with-cross-build`" takes an absolute path.
    
    cd /buildB
    sh /icu/source/configure --host=**i586-pc-haiku** --with-cross-build=**/buildA**
    gnumake
    
5.  Tests and testdata can be built with "gnumake tests".

[How To Package ICU](#HowToPackage)
-----------------------------------

There are many ways that a person can package ICU with their software products. Usually only the libraries need to be considered for packaging.

On UNIX, you should use "gmake install" to make it easier to develop and package ICU. The bin, lib and include directories are needed to develop applications that use ICU. These directories will be created relative to the "--prefix=_dir_" configure option (See the [UNIX build instructions](#HowToBuildUNIX)). When ICU is built on Windows, a similar directory structure is built.

When changes have been made to the standard ICU distribution, it is recommended that at least one of the following guidelines be followed for special packaging.

1.  Add a suffix name to the library names. This can be done with the --with-library-suffix configure option.
2.  The installation script should install the ICU libraries into the application's directory.

Following these guidelines prevents other applications that use a standard ICU distribution from conflicting with any libraries that you need. On operating systems that do not have a standard C++ ABI (name mangling) for compilers, it is recommended to do this special packaging anyway. More details on customizing ICU are available in the [User's Guide](http://userguide.icu-project.org/). The [ICU Source Code Organization](#SourceCode) section of this readme.html gives a more complete description of the libraries.

Here is an example of libraries that are frequently packaged.

Library Name

Windows Filename

Linux Filename

Comment

Data Library

icudt_XY_l.dll

libicudata.so._XY_._Z_

Data required by the Common and I18n libraries. There are many ways to package and [customize this data](http://userguide.icu-project.org/icudata), but by default this is all you need.

Common Library

icuuc_XY_.dll

libicuuc.so._XY_._Z_

Base library required by all other ICU libraries.

Internationalization (i18n) Library

icuin_XY_.dll

libicui18n.so._XY_._Z_

A library that contains many locale based internationalization (i18n) functions.

Layout Engine

icule_XY_.dll

libicule.so._XY_._Z_

An optional engine for doing font layout.

Layout Extensions Engine

iculx_XY_.dll

libiculx.so._XY_._Z_

An optional engine for doing font layout that uses parts of ICU.

ICU I/O (Unicode stdio) Library

icuio_XY_.dll

libicuio.so._XY_._Z_

An optional library that provides a stdio like API with Unicode support.

Tool Utility Library

icutu_XY_.dll

libicutu.so._XY_._Z_

An internal library that contains internal APIs that are only used by ICU's tools. If you do not use ICU's tools, you do not need this library.

Normally only the above ICU libraries need to be considered for packaging. The versionless symbolic links to these libraries are only needed for easier development. The _X_, _Y_ and _Z_ parts of the name are the version numbers of ICU. For example, ICU 2.0.2 would have the name libicuuc.so.20.2 for the common library. The exact format of the library names can vary between platforms due to how each platform can handles library versioning.

[Important Notes About Using ICU](#ImportantNotes)
--------------------------------------------------

### [Using ICU in a Multithreaded Environment](#ImportantNotesMultithreaded)

Some versions of ICU require calling the `u_init()` function from `uclean.h` to ensure that ICU is initialized properly. In those ICU versions, `u_init()` must be called before ICU is used from multiple threads. There is no harm in calling `u_init()` in a single-threaded application, on a single-CPU machine, or in other cases where `u_init()` is not required.

In addition to ensuring thread safety, `u_init()` also attempts to load at least one ICU data file. Assuming that all data files are packaged together (or are in the same folder in files mode), a failure code from `u_init()` usually means that the data cannot be found. In this case, the data may not be installed properly, or the application may have failed to call `udata_setCommonData()` or `u_setDataDirectory()` which specify to ICU where it can find its data.

Since `u_init()` will load only one or two data files, it cannot guarantee that all of the data that an application needs is available. It cannot check for all data files because the set of files is customizable, and some ICU services work without loading any data at all. An application should always check for error codes when opening ICU service objects (using `ucnv_open()`, `ucol_open()`, C++ constructors, etc.).

#### ICU 3.4 and later

ICU 3.4 self-initializes properly for multi-threaded use. It achieves this without performance penalty by hardcoding the core Unicode properties data, at the cost of some flexibility. (For details see Jitterbug 4497.)

`u_init()` can be used to check for data loading. It tries to load the converter alias table (`cnvalias.icu`).

#### ICU 2.6..3.2

These ICU versions require a call to `u_init()` before multi-threaded use. The services that are directly affected are those that don't have a service object and need to be fast: normalization and character properties.

`u_init()` loads and initializes the data files for normalization and character properties (`unorm.icu` and `uprops.icu`) and can therefore also be used to check for data loading.

#### ICU 2.4 and earlier

ICU 2.4 and earlier versions were not prepared for multithreaded use on multi-CPU platforms where the CPUs implement weak memory coherency. These CPUs include: Power4, Power5, Alpha, Itanium. `u_init()` was not defined yet.

#### [Using ICU in a Multithreaded Environment on HP-UX](#ImportantNotesHPUX)

When ICU is built with aCC on HP-UX, the [-AA](http://h21007.www2.hp.com/portal/site/dspp/menuitem.863c3e4cbcdc3f3515b49c108973a801?ciid=eb08b3f1eee02110b3f1eee02110275d6e10RCRD) compiler flag is used. It is required in order to use the latest <iostream> API in a thread safe manner. This compiler flag affects the version of the C++ library being used. Your applications will also need to be compiled with -AA in order to use ICU.

#### [Using ICU in a Multithreaded Environment on Solaris](#ImportantNotesSolaris)

##### Linking on Solaris

In order to avoid synchronization and threading issues, developers are **suggested** to strictly follow the compiling and linking guidelines for multithreaded applications, specified in the following document from Sun Microsystems. Most notably, pay strict attention to the following statements from Sun:

> To use libthread, specify -lthread before -lc on the ld command line, or last on the cc command line.
> 
> To use libpthread, specify -lpthread before -lc on the ld command line, or last on the cc command line.

Failure to do this may cause spurious lock conflicts, recursive mutex failure, and deadlock.

Source: "_Solaris Multithreaded Programming Guide, Compiling and Debugging_", Sun Microsystems, Inc., Apr 2004  
[http://docs.sun.com/app/docs/doc/816-5137/6mba5vpke?a=view](http://docs.sun.com/app/docs/doc/816-5137/6mba5vpke?a=view)

### [Windows Platform](#ImportantNotesWindows)

If you are building on the Win32 platform, it is important that you understand a few of the following build details.

#### DLL directories and the PATH setting

As delivered, the International Components for Unicode build as several DLLs, which are placed in the "_<ICU>_\\bin" directory. You must add this directory to the PATH environment variable in your system, or any executables you build will not be able to access International Components for Unicode libraries. Alternatively, you can copy the DLL files into a directory already in your PATH, but we do not recommend this. You can wind up with multiple copies of the DLL and wind up using the wrong one.

#### Changing your PATH

**Windows 2000/XP**: Use the System Icon in the Control Panel. Pick the "Advanced" tab. Select the "Environment Variables..." button. Select the variable PATH in the lower box, and select the lower "Edit..." button. In the "Variable Value" box, append the string ";_<ICU>_\\bin" to the end of the path string. If there is nothing there, just type in "_<ICU>_\\bin". Click the Set button, then the OK button.

Note: When packaging a Windows application for distribution and installation on user systems, copies of the ICU DLLs should be included with the application, and installed for exclusive use by the application. This is the only way to insure that your application is running with the same version of ICU, built with exactly the same options, that you developed and tested with. Refer to Microsoft's guidelines on the usage of DLLs, or search for the phrase "DLL hell" on [msdn.microsoft.com](http://msdn.microsoft.com/).

### [UNIX Type Platform](#ImportantNotesUNIX)

If you are building on a UNIX platform, and if you are installing ICU in a non-standard location, you may need to add the location of your ICU libraries to your **LD\_LIBRARY\_PATH** or **LIBPATH** environment variable (or the equivalent runtime library path environment variable for your system). The ICU libraries may not link or load properly without doing this.

Note that if you do not want to have to set this variable, you may instead use the --enable-rpath option at configuration time. This option will instruct the linker to always look for the libraries where they are installed. You will need to use the appropriate linker options when linking your own applications and libraries against ICU, too. Please refer to your system's linker manual for information about runtime paths. The use of rpath also means that when building a new version of ICU you should not have an older version installed in the same place as the new version's installation directory, as the older libraries will used during the build, instead of the new ones, likely leading to an incorrectly build ICU. This is the proper behavior of rpath.

[Platform Dependencies](#PlatformDependencies)
----------------------------------------------

### [Porting To A New Platform](#PlatformDependenciesNew)

If you are using ICU's Makefiles to build ICU on a new platform, there are a few places where you will need to add or modify some files. If you need more help, you can always ask the [icu-support mailing list](http://site.icu-project.org/contacts). Once you have finished porting ICU to a new platform, it is recommended that you contribute your changes back to ICU via the icu-support mailing list. This will make it easier for everyone to benefit from your work.

#### Data For a New Platform

For some people, it may not be necessary for completely build ICU. Most of the makefiles and build targets are for tools that are used for building ICU's data, and an application's data (when an application uses ICU resource bundles for its data).

Data files can be built on a different platform when both platforms share the same endianness and the same charset family. This assertion does not include platform dependent DLLs/shared/static libraries. For details see the User Guide [ICU Data](http://userguide.icu-project.org/icudata) chapter.

ICU 3.6 removes the requirement that ICU be completely built in the native operating environment. It adds the icupkg tool which can be run on any platform to turn binary ICU data files from any one of the three formats into any one of the other data formats. This allows a application to use ICU data built anywhere to be used for any other target platform.

**WARNING!** Building ICU without running the tests is not recommended. The tests verify that ICU is safe to use. It is recommended that you try to completely port and test ICU before using the libraries for your own application.

#### Adapting Makefiles For a New Platform

Try to follow the build steps from the [UNIX](#HowToBuildUNIX) build instructions. If the configure script fails, then you will need to modify some files. Here are the usual steps for porting to a new platform:  

1.  Create an mh file in icu/source/config/. You can use mh-linux or a similar mh file as your base configuration.
2.  Modify icu/source/aclocal.m4 to recognize your platform's mh file.
3.  Modify icu/source/configure.in to properly set your **platform** C Macro define.
4.  Run [autoconf](http://www.gnu.org/software/autoconf/) in icu/source/ without any options. The autoconf tool is standard on most Linux systems.
5.  If you have any optimization options that you want to normally use, you can modify icu/source/runConfigureICU to specify those options for your platform.
6.  Build and test ICU on your platform. It is very important that you run the tests. If you don't run the tests, there is no guarentee that you have properly ported ICU.

### [Platform Dependent Implementations](#PlatformDependenciesImpl)

The platform dependencies have been mostly isolated into the following files in the common library. This information can be useful if you are porting ICU to a new platform.

*   **unicode/platform.h.in** (autoconf'ed platforms)  
    **unicode/p_XXXX_.h** (others: pwin32.h, ppalmos.h, ..): Platform-dependent typedefs and defines:  
      
    
    *   Generic types like UBool, int8\_t, int16\_t, int32\_t, int64\_t, uint64_t etc.
    *   U\_EXPORT and U\_IMPORT for specifying dynamic library import and export
    *   String handling support for the char16\_t and wchar\_t types.
    
      
    
*   **unicode/putil.h, putil.c**: platform-dependent implementations of various functions that are platform dependent:  
      
    
    *   uprv\_isNaN, uprv\_isInfinite, uprv\_getNaN and uprv\_getInfinity for handling special floating point values.
    *   uprv\_tzset, uprv\_timezone, uprv_tzname and time for getting platform specific time and time zone information.
    *   u_getDataDirectory for getting the default data directory.
    *   uprv_getDefaultLocaleID for getting the default locale setting.
    *   uprv_getDefaultCodepage for getting the default codepage encoding.
    
      
    
*   **umutex.h, umutex.c**: Code for doing synchronization in multithreaded applications. If you wish to use International Components for Unicode in a multithreaded application, you must provide a synchronization primitive that the classes can use to protect their global data against simultaneous modifications. We already supply working implementations for many platforms that ICU builds on.  
      
    
*   **umapfile.h, umapfile.c**: functions for mapping or otherwise reading or loading files into memory. All access by ICU to data from files makes use of these functions.  
      
    
*   Using platform specific #ifdef macros are highly discouraged outside of the scope of these files. When the source code gets updated in the future, these #ifdef's can cause testing problems for your platform.

* * *

Copyright © 1997-2015 International Business Machines Corporation and others. All Rights Reserved.  
IBM Globalization Center of Competency - San José  
4400 North First Street  
San José, CA 95134  
USA
