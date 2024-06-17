#!/bin/bash

# Defina o nome do arquivo de changelog
CHANGELOG_FILE="CHANGELOG.md"

# Defina a branch atual
BRANCH_NAME=$(git symbolic-ref --short HEAD)

# Defina a branch base para comparação
if [[ "$BRANCH_NAME" == "develop" ]]; then
  BASE_BRANCH="master"
elif [[ "$BRANCH_NAME" == feature/* ]]; then
  BASE_BRANCH="develop"
elif [[ "$BRANCH_NAME" == hotfix/* ]]; then
  BASE_BRANCH="master"
elif [[ "$BRANCH_NAME" == release/* ]]; then
  BASE_BRANCH="develop"
elif [[ "$BRANCH_NAME" == "master" ]]; then
  BASE_BRANCH="develop"
else
  echo "Branch desconhecida: $BRANCH_NAME"
  exit 1
fi

# Obtém o commit de divergência entre a branch atual e a base
MERGE_BASE=$(git merge-base $BRANCH_NAME $BASE_BRANCH)

# Cria ou limpa o arquivo de changelog
echo "<img src=\"$LOGO_URL\" align=\"right\" width=\"100\" style=\"margin-left: 20px;\" />" > $CHANGELOG_FILE
echo "" >> $CHANGELOG_FILE
echo "# Changelog" >> $CHANGELOG_FILE
echo "" >> $CHANGELOG_FILE

# Adiciona cabeçalhos para os tipos de commit
echo "## Features" >> $CHANGELOG_FILE
echo "" >> $CHANGELOG_FILE

# Lista os commits do tipo 'feat' associados à tag com detalhes
git log $MERGE_BASE..HEAD --grep='^feat' --pretty=format:"- [%h](https://gitlab.com/username/repository/commit/%H) **%s** (%an, %ad)" --date=format:'%d-%m-%Y' >> $CHANGELOG_FILE

echo "" >> $CHANGELOG_FILE
echo "## Fixes" >> $CHANGELOG_FILE
echo "" >> $CHANGELOG_FILE

# Lista os commits do tipo 'fix' associados à tag com detalhes
git log $MERGE_BASE..HEAD --grep='^fix' --pretty=format:"- [%h](https://gitlab.com/username/repository/commit/%H) **%s** (%an, %ad)" --date=format:'%d-%m-%Y' >> $CHANGELOG_FILE

echo "" >> $CHANGELOG_FILE
echo "## Chores" >> $CHANGELOG_FILE
echo "" >> $CHANGELOG_FILE

# Lista os commits do tipo 'chore' associados à tag com detalhes
git log $MERGE_BASE..HEAD --grep='^chore' --pretty=format:"- [%h](https://gitlab.com/username/repository/commit/%H) **%s** (%an, %ad)" --date=format:'%d-%m-%Y' >> $CHANGELOG_FILE

# Adicione seções adicionais conforme necessário, como 'refactor', 'docs', 'style', etc.
echo "" >> $CHANGELOG_FILE
echo "## Refactors" >> $CHANGELOG_FILE
echo "" >> $CHANGELOG_FILE

# Lista os commits do tipo 'refactor' associados à tag com detalhes
git log $MERGE_BASE..HEAD --grep='^refactor' --pretty=format:"- [%h](https://gitlab.com/username/repository/commit/%H) **%s** (%an, %ad)" --date=format:'%d-%m-%Y' >> $CHANGELOG_FILE

echo "" >> $CHANGELOG_FILE
echo "## Documentation" >> $CHANGELOG_FILE
echo "" >> $CHANGELOG_FILE

# Lista os commits do tipo 'docs' associados à tag com detalhes
git log $MERGE_BASE..HEAD --grep='^docs' --pretty=format:"- [%h](https://gitlab.com/username/repository/commit/%H) **%s** (%an, %ad)" --date=format:'%d-%m-%Y' >> $CHANGELOG_FILE

echo "" >> $CHANGELOG_FILE
echo "## Styles" >> $CHANGELOG_FILE
echo "" >> $CHANGELOG_FILE

# Lista os commits do tipo 'style' associados à tag com detalhes
git log $MERGE_BASE..HEAD --grep='^style' --pretty=format:"- [%h](https://gitlab.com/username/repository/commit/%H) **%s** (%an, %ad)" --date=format:'%d-%m-%Y' >> $CHANGELOG_FILE

echo "" >> $CHANGELOG_FILE
echo "## Tests" >> $CHANGELOG_FILE
echo "" >> $CHANGELOG_FILE

# Lista os commits do tipo 'test' associados à tag com detalhes
git log $MERGE_BASE..HEAD --grep='^test' --pretty=format:"- [%h](https://gitlab.com/username/repository/commit/%H) **%s** (%an, %ad)" --date=format:'%d-%m-%Y' >> $CHANGELOG_FILE

echo "" >> $CHANGELOG_FILE
echo "## Other" >> $CHANGELOG_FILE
echo "" >> $CHANGELOG_FILE

# Lista os commits que não se enquadram nas categorias acima
git log $MERGE_BASE..HEAD --invert-grep --grep='^feat\|^fix\|^chore\|^refactor\|^docs\|^style\|^test' --pretty=format:"- [%h](https://gitlab.com/username/repository/commit/%H) **%s** (%an, %ad)" --date=format:'%d-%m-%Y' >> $CHANGELOG_FILE

echo "Changelog gerado com sucesso no arquivo $CHANGELOG_FILE"
