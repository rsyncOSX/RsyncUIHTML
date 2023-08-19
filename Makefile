all: release
debug:
	xcodebuild -derivedDataPath $(PWD) -configuration Debug -scheme RsyncUIHTML
release:
	xcodebuild -derivedDataPath $(PWD) -configuration Release -scheme RsyncUIHTML
clean:
	rm -Rf Build
	rm -Rf ModuleCache.noindex
	rm -Rf info.plist
	rm -Rf Logs
	rm -rf SourcePackages
	rm -rf SDKStatCaches.noindex
