Function Register-GitAlias {
    param (
        [string]$AliasName,
        [string]$Type = ""
    )
    
    if (-not $Type) { $Type = $AliasName }

    $bashScript = "!f() { [[ -z `"`$GIT_PREFIX`" ]] || cd `"`$GIT_PREFIX`"; local scope=`"`" bang=`"`"; while [[ `$# -gt 0 ]]; do case `"`$1`" in -s) scope=`"(`$2)`"; shift 2 ;; -w) bang=`"!`"; shift 1 ;; *) break ;; esac; done; if [ -z `"`$1`" ]; then git commit -m `"$Type`${scope}${bang}: `" -e; else git commit -m `"$Type`${scope}${bang}: `${*}`"; fi }; f"

    git config --global alias.$AliasName $bashScript
}

Write-Host "Installing git aliases..."

$semanticAliases = @("chore", "docs", "feat", "fix", "localize", "refactor", "style", "test", "ci", "build", "perf")

foreach ($alias in $semanticAliases) {
    Register-GitAlias -AliasName $alias
}

try {
    if (Get-Command "git-extras" -ErrorAction SilentlyContinue) {
        Register-GitAlias -AliasName "ch" -Type "chore"
        Register-GitAlias -AliasName "rf" -Type "refactor"
    }
} catch {}

Write-Host
Write-Host 'Done! Now you can use semantic commits.'
Write-Host 'See: https://github.com/pallax03/git-semantic-commits for more information.'