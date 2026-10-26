class BtHub < Formula
  desc "Menu bar app to move Bluetooth audio devices between your Macs"
  homepage "https://github.com/Salamahin/bt-hub"
  url "https://github.com/Salamahin/bt-hub/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "e1623525361a4058b7521225503ae50f3246444e5e1dc86ab9a66d8de5cbfdb6"

  depends_on macos: :sonoma

  def install
    ENV["SWIFT_BUILD_FLAGS"] = "--disable-sandbox"
    system "scripts/build-app.sh"
    prefix.install "build/BT Hub.app"
  end

  service do
    run [opt_prefix/"BT Hub.app/Contents/MacOS/BTHub"]
    run_type :immediate
  end

  def caveats
    <<~EOS
      Start BT Hub now and at every login:
        brew services start bt-hub

      To also see it in Launchpad and Spotlight:
        ln -sf "#{opt_prefix}/BT Hub.app" ~/Applications/
    EOS
  end

  test do
    assert_predicate prefix/"BT Hub.app/Contents/MacOS/BTHub", :executable?
    assert_match "dev.salamahin.bthub", shell_output("/usr/libexec/PlistBuddy -c 'Print CFBundleIdentifier' '#{prefix}/BT Hub.app/Contents/Info.plist'")
  end
end
