class BtHub < Formula
  desc "Menu bar app to move Bluetooth audio devices between your Macs"
  homepage "https://github.com/Salamahin/bt-hub"
  url "https://github.com/Salamahin/bt-hub/archive/refs/tags/v1.4.1.tar.gz"
  sha256 "332b84762962db5afde78d1cef136d7b1d14737884bfabbc8a9ca14a9d32d093"

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
