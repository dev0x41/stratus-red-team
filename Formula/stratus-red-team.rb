# typed: false
# frozen_string_literal: true

# This file was generated by GoReleaser. DO NOT EDIT.
class StratusRedTeam < Formula
  desc ""
  homepage "https://stratus-red-team.cloud"
  version "0.0.21"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/DataDog/stratus-red-team/releases/download/v0.0.21/stratus-red-team_0.0.21_Darwin_arm64.tar.gz"
      sha256 "858b4b565be2c86a07b146311f85229ad7193e3ad3b55cda56d3fd93a2f88e59"

      def install
        bin.install "stratus"
      end
    end
    if Hardware::CPU.intel?
      url "https://github.com/DataDog/stratus-red-team/releases/download/v0.0.21/stratus-red-team_0.0.21_Darwin_x86_64.tar.gz"
      sha256 "c3a3b9d184a5911cf667ff51523da945fc006ca2013e69ebce87f44f261c97b5"

      def install
        bin.install "stratus"
      end
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/DataDog/stratus-red-team/releases/download/v0.0.21/stratus-red-team_0.0.21_Linux_x86_64.tar.gz"
      sha256 "f6c0455a38d42487216f7d196add6e83d5d7048948c251f657ddab30bb787e5f"

      def install
        bin.install "stratus"
      end
    end
    if Hardware::CPU.arm? && Hardware::CPU.is_64_bit?
      url "https://github.com/DataDog/stratus-red-team/releases/download/v0.0.21/stratus-red-team_0.0.21_Linux_arm64.tar.gz"
      sha256 "ec21f3bc0ea07e346a14a84b260cc93498c9b4cc251e028dda541772d2c9d317"

      def install
        bin.install "stratus"
      end
    end
  end
end
