# Install script for directory: /uio/hume/student-u88/johnrav/in4140/crust_crawler_simulator/src/crustcrawler_simulation/crustcrawler_description

# Set the install prefix
if(NOT DEFINED CMAKE_INSTALL_PREFIX)
  set(CMAKE_INSTALL_PREFIX "/uio/hume/student-u88/johnrav/in4140/crust_crawler_simulator/install")
endif()
string(REGEX REPLACE "/$" "" CMAKE_INSTALL_PREFIX "${CMAKE_INSTALL_PREFIX}")

# Set the install configuration name.
if(NOT DEFINED CMAKE_INSTALL_CONFIG_NAME)
  if(BUILD_TYPE)
    string(REGEX REPLACE "^[^A-Za-z0-9_]+" ""
           CMAKE_INSTALL_CONFIG_NAME "${BUILD_TYPE}")
  else()
    set(CMAKE_INSTALL_CONFIG_NAME "")
  endif()
  message(STATUS "Install configuration: \"${CMAKE_INSTALL_CONFIG_NAME}\"")
endif()

# Set the component getting installed.
if(NOT CMAKE_INSTALL_COMPONENT)
  if(COMPONENT)
    message(STATUS "Install component: \"${COMPONENT}\"")
    set(CMAKE_INSTALL_COMPONENT "${COMPONENT}")
  else()
    set(CMAKE_INSTALL_COMPONENT)
  endif()
endif()

# Install shared libraries without execute permission?
if(NOT DEFINED CMAKE_INSTALL_SO_NO_EXE)
  set(CMAKE_INSTALL_SO_NO_EXE "1")
endif()

# Is this installation the result of a crosscompile?
if(NOT DEFINED CMAKE_CROSSCOMPILING)
  set(CMAKE_CROSSCOMPILING "FALSE")
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xUnspecifiedx" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/pkgconfig" TYPE FILE FILES "/uio/hume/student-u88/johnrav/in4140/crust_crawler_simulator/build/crustcrawler_simulation/crustcrawler_description/catkin_generated/installspace/crustcrawler_description.pc")
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xUnspecifiedx" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/share/crustcrawler_description/cmake" TYPE FILE FILES
    "/uio/hume/student-u88/johnrav/in4140/crust_crawler_simulator/build/crustcrawler_simulation/crustcrawler_description/catkin_generated/installspace/crustcrawler_descriptionConfig.cmake"
    "/uio/hume/student-u88/johnrav/in4140/crust_crawler_simulator/build/crustcrawler_simulation/crustcrawler_description/catkin_generated/installspace/crustcrawler_descriptionConfig-version.cmake"
    )
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xUnspecifiedx" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/share/crustcrawler_description" TYPE FILE FILES "/uio/hume/student-u88/johnrav/in4140/crust_crawler_simulator/src/crustcrawler_simulation/crustcrawler_description/package.xml")
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xUnspecifiedx" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/share/crustcrawler_description" TYPE DIRECTORY FILES
    "/uio/hume/student-u88/johnrav/in4140/crust_crawler_simulator/src/crustcrawler_simulation/crustcrawler_description/launch"
    "/uio/hume/student-u88/johnrav/in4140/crust_crawler_simulator/src/crustcrawler_simulation/crustcrawler_description/meshes"
    "/uio/hume/student-u88/johnrav/in4140/crust_crawler_simulator/src/crustcrawler_simulation/crustcrawler_description/urdf"
    )
endif()

