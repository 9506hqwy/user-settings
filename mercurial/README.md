# mercurial

## Location

- Windows
  - *%USERPROFILE%*
- Linux
  - *$HOME*

## Notes

- Windows
  - `less` default encoding is utf-8. Configure one method of following.
    - `LESSCHARSET` is `dos`.
    - `HGENCODING` is `utf-8` and ternimal charset is utf-8 (65001).
  - `-m` option does not work correctly because cmdline option encoding is sjis.

## References

- [Configuration Files](https://www.mercurial-scm.org/help/topics/config)
