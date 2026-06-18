@echo on

:: Install cargo-license
:: Set up rust environment
set CARGO_HOME=%CONDA_PREFIX%\.cargo.win
set CARGO_CONFIG=%CARGO_HOME%\config
set RUSTUP_HOME=%CARGO_HOME%\rustup
set CARGO_PROFILE_RELEASE_STRIP=symbols
set CARGO_PROFILE_RELEASE_LTO=fat
icacls %CARGO_HOME% /grant Users:F

echo "Building %PKG_NAME%"

:: Set up a temporary directory so that msvc and gnu
:: versions are not installed into the same directory
md %CD%\build-%PKG_NAME%
set TEMP=%CD%\build-%PKG_NAME%

:: Needed to bootstrap istelf into the conda ecosystem
cargo auditable install cargo-bundle-licenses
:: Check that all downstream libraries licenses are present
set PATH=%PATH%;%CARGO_HOME%\bin
cargo bundle-licenses --format yaml --output CI.THIRDPARTY.yml --previous THIRDPARTY.yml --check-previous

:: build
cargo auditable install --no-track --locked --root "%PREFIX%" --path . || goto :error

goto :EOF

:error
echo Failed with error #%errorlevel%.
exit 1
