repositories.remote << 'http://repo1.maven.org/maven2'

require "buildr/scala"

desc "The parent project"
define "parboiled" do
  project.version = "0.10.0-SNAPSHOT"
  project.group = "sirthias"
  manifest["Implementation-Vendor"] = "COPYRIGHT"

  ASM_ALL = "asm:asm-all:jar:3.3"
  GOOGLE_COLLECTIONS = "com.google.collections:google-collections:jar:1.0"
  SCALATEST = "org.scalatest:scalatest:jar:1.2"

  compile.using :deprecation => true, :target => "1.5", :other => %w{-encoding UTF-8}, :lint=> "all"

  desc "The core parts of parboiled, depended on by everything else"
  define "core" do
    compile.with GOOGLE_COLLECTIONS
    test.using :testng
    package :jar
  end

  desc "The Java DSL and supporting code"
  define "java" do
    compile.with ASM_ALL, GOOGLE_COLLECTIONS, project("core")
    test.using :testng
    package :jar
  end

  desc "The Scala DSL and supporting code"
  define "scala" do
    compile.with GOOGLE_COLLECTIONS, project("core")
    test.with SCALATEST
    test.using :testng
    package :jar
  end

  desc "Examples using the Java DSL"
  define "examples-java" do
    compile.with ASM_ALL, GOOGLE_COLLECTIONS, project("core"), project("java")
    test.using :testng
    package :jar
  end

  desc "Examples using the Scala DSL"
  define "examples-scala" do
    compile.with GOOGLE_COLLECTIONS, project("core"), project("scala")
    test.with SCALATEST
    test.using :testng
    package :jar
  end
end