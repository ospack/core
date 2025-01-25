<!-- Use [x] to mark item done, or just click the checkboxes with device pointer -->

- [ ] Have you followed the [guidelines for contributing](https://github.com/ospack/core/blob/HEAD/CONTRIBUTING.md)?
- [ ] Have you ensured that your commits follow the [commit style guide](https://docs.ospack.github.io/Formula-Cookbook#commit)?
- [ ] Have you checked that there aren't other open [pull requests](https://github.com/ospack/core/pulls) for the same formula update/change?
- [ ] Have you built your formula locally with `OSPACK_NO_INSTALL_FROM_API=1 ospack install --build-from-source <formula>`, where `<formula>` is the name of the formula you're submitting?
- [ ] Is your test running fine `ospack test <formula>`, where `<formula>` is the name of the formula you're submitting?
- [ ] Does your build pass `ospack audit --strict <formula>` (after doing `OSPACK_NO_INSTALL_FROM_API=1 ospack install --build-from-source <formula>`)? If this is a new formula, does it pass `ospack audit --new <formula>`?

-----
