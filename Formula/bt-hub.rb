class BtHub < Formula
  desc "Menu bar app to move Bluetooth audio devices between your Macs"
  homepage "https://github.com/Salamahin/bt-hub"
  url "https://github.com/Salamahin/bt-hub/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "4e4254085bc497ef46ee9f25cb00225d4666cda7b38ce5ec5a9f466a1c947069"

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
    app = prefix/"BT Hub.app"
    assert_predicate app/"Contents/MacOS/BTHub", :executable?
    assert_match "dev.salamahin.bthub",
                 shell_output("/usr/libexec/PlistBuddy -c 'Print CFBundleIdentifier' '#{app}/Contents/Info.plist'")
  end
end
