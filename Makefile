# Workforce Flux — common build tasks.
# dbt is run from inside hr_dbt/ with --profiles-dir .

.PHONY: build docs

# Build the pipeline: install deps, load seed, run models, run tests.
build:
	cd hr_dbt && dbt deps && dbt build --profiles-dir .

# Regenerate the static dbt docs site served at docs.workforceflux.kdayno.com.
# Generates a single self-contained HTML file, copies it to docs_site/, and
# strips the local absolute project path so it isn't published.
docs:
	cd hr_dbt && dbt docs generate --static --profiles-dir .
	cp hr_dbt/target/static_index.html docs_site/index.html
	perl -i -pe 's{$(CURDIR)/hr_dbt}{/workforce-flux/hr_dbt}g' docs_site/index.html
	@echo "docs_site/index.html regenerated and sanitised."
