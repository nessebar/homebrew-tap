# CortexDJ cask for the project's OWN tap (github.com/nessebar/homebrew-tap),
# not homebrew/cask: see docs/distribution/homebrew.md for why.
#
#   brew install --cask nessebar/tap/cortexdj
#
# Written by tools/homebrew_cask.py from packaging/homebrew/cortexdj.rb.in at
# every macOS release. Change the template, not the cask.
cask "cortexdj" do
  version "2.38.7"
  sha256 "2625454c403e68ef0ec637192ea772eea879f1c12a4061d4fb727d9be5978bf0"

  # The VERSIONED, immutable object. Never the CortexDJ-macOS-arm64.zip alias:
  # it changes under the same name every release and would fail the checksum.
  url "https://dl.cortexdj.com/CortexDJ-macOS-arm64-#{version}.zip"
  name "CortexDJ"
  desc "Offline AI DJ that builds and renders sets from your own music"
  homepage "https://cortexdj.com/"

  # The app's own update manifest. It keeps an unsigned top-level "version" for
  # this check (aidj/updater.py, SIGNED MANIFESTS).
  livecheck do
    url "https://cortexdj.com/updates/latest-mac.json"
    strategy :json do |json|
      json["version"]
    end
  end

  # CortexDJ reads latest-mac.json itself and updates in place (2.35 and later).
  auto_updates true
  depends_on arch: :arm64
  # LSMinimumSystemVersion 13.0 in aidj-macos.spec. A bare symbol is a
  # minimum (Homebrew 5.1.12 and later; brew style rewrites ">= :name" to it).
  depends_on macos: :ventura

  app "CortexDJ.app"

  # Settings, licence and library live in ~/CortexDJ (aidj/config.py _dir():
  # APPDATA, which macOS does not set, else the home folder). The rest is what
  # macOS and Qt may keep for the app.
  zap trash: [
    "~/CortexDJ",
    "~/Library/Application Support/CortexDJ",
    "~/Library/Caches/CortexDJ",
    "~/Library/Preferences/com.cortexdj.app.plist",
    "~/Library/Saved Application State/com.cortexdj.app.savedState",
  ]
end
