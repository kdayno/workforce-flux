<script>
	import '@evidence-dev/tailwind/fonts.css';
	import '../app.css';
	import { EvidenceDefaultLayout } from '@evidence-dev/core-components';
	export let data;
</script>

<EvidenceDefaultLayout
	{data}
	homePageName="Overview"
	hideBreadcrumbs={true}
	githubRepo="https://github.com/kdayno/workforce-flux"
>
	<slot slot="content" />
</EvidenceDefaultLayout>
