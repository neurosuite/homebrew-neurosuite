# Neurosuite Homebrew tap

Homebrew formulae for [NeuroScope](https://github.com/neurosuite/neuroscope),
[Klusters](https://github.com/neurosuite/klusters), [NDManager](https://github.com/neurosuite/ndmanager),
the [NDManager plugins](https://github.com/neurosuite/ndmanager-plugins) and the library they share,
[libneurosuite](https://github.com/neurosuite/libneurosuite).

```bash
brew tap neurosuite/neurosuite
brew install neuroscope klusters ndmanager ndmanager-plugins
```

The formulae build from source with Qt 6 from Homebrew and currently track the 3.0.0 release
candidates. The applications are started from the terminal (`neuroscope`, `klusters`, `ndmanager`).
Disk images to drag into Applications are on the release pages of each application.

This tap replaces `FlorianFranzen/spikesorting`, which has the Qt 4/Qt 5 versions and no longer
builds.

Problems with the formulae can be reported in the [issues](https://github.com/neurosuite/homebrew-neurosuite/issues)
of this repository, problems with the applications in their own repositories.
