#!/usr/bin/env ruby

require 'formula'

class BugsnagDsymUpload < Formula

  homepage 'https://docs.bugsnag.com/api/dsym-upload'
  head 'https://github.com/bugsnag/bugsnag-upload'
  url 'https://github.com/bugsnag/bugsnag-upload/archive/v1.3.0.tar.gz'

  def install
    system "make", "BINDIR=#{bin}", "MANDIR=#{man}", "install"
  end

  test do
    system bin/"bugsnag-dsym-upload", "--help"
  end
end

