class Bbl < Formula
  desc "Read/search Holy Bible in your terminal"
  homepage "https://github.com/nehemiaharchives/bbl"
  version "v2.0"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/nehemiaharchives/bbl/releases/download/v2.0/bbl-v2.0-macos-arm64-homebrew.tar.gz"
      sha256 "9ec3262e4205e13d9a6c1e8945428eb976693bc2233c347968ceeffe2211fef4"
    end

    on_intel do
      url "https://github.com/nehemiaharchives/bbl/releases/download/v2.0/bbl-v2.0-macos-x64-homebrew.tar.gz"
      sha256 "7cafbbff3f395a398cc64f9985be3fd03f999042caad8e95b627d2b358fa3414"
    end
  end

  def install
    libexec.install "bbl", "bbl-search-common"
    (prefix/"packs").install "webus.zip"

    bash_completion.install "bbl.bash" => "bbl"
    zsh_completion.install "_bbl"
    fish_completion.install "bbl.fish"

    (bin/"bbl").write <<~SH
      #!/bin/bash
      set -e
      mkdir -p "$HOME/.bbl/bin" "$HOME/.bbl/packs"

      if ! cmp -s "#{libexec}/bbl-search-common" "$HOME/.bbl/bin/bbl-search-common"; then
        install -m 0755 "#{libexec}/bbl-search-common" "$HOME/.bbl/bin/bbl-search-common"
      fi

      if ! cmp -s "#{prefix}/packs/webus.zip" "$HOME/.bbl/packs/webus.zip"; then
        install -m 0644 "#{prefix}/packs/webus.zip" "$HOME/.bbl/packs/webus.zip"
      fi

      exec "#{libexec}/bbl" "$@"
    SH
  end

  test do
    assert_match(/God|god/, shell_output("#{bin}/bbl john 3:16"))
    assert_match(/God|god/, shell_output("#{bin}/bbl search God limit 1"))
  end

  def caveats
    <<~EOS
      bbl shell completions installed:
        bash: source #{bash_completion}/bbl
        zsh:  autoload -Uz compinit && compinit
        fish:  auto-sourced from #{fish_completion}/bbl.fish
    EOS
  end
end
