:: Install cargo-license
:: Set up rust environment
set CARGO_HOME=%CONDA_PREFIX%\.cargo.win
set CARGO_CONFIG=%CARGO_HOME%\config
set RUSTUP_HOME=%CARGO_HOME%\rustup
icacls %CARGO_HOME% /grant Users:F

:: Needed to bootstrap istelf into the conda ecosystem
cargo install cargo-bundle-licenses
:: Check that all downstream libraries licenses are present
set PATH=%PATH%;%CARGO_HOME%\bin
cargo bundle-licenses --format yaml --output CI.THIRDPARTY.yml --previous THIRDPARTY.yml --check-previous

:: build
cargo install --locked --root "%PREFIX%" --path . || goto :error

:: strip debug symbols
strip "%PREFIX%\bin\cargo-bundle-licenses.exe" || goto :error

:: remove extra build file
del /F /Q "%PREFIX%\.crates.toml"

goto :EOF

:error
echo Failed with error #%errorlevel%.
exit 1
