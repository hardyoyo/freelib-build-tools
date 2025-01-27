# freelib-build-tools <br/>![Maven Build](https://github.com/ksclarke/freelib-build-tools/workflows/Maven%20PR%20Build/badge.svg) [![Known Vulnerabilities](https://snyk.io/test/github/ksclarke/freelib-build-tools/badge.svg)](https://snyk.io/test/github/ksclarke/freelib-build-tools) [![Maven Central](https://img.shields.io/maven-central/v/info.freelibrary/freelib-build-tools?colorB=brightgreen)](https://search.maven.org/artifact/info.freelibrary/freelib-build-tools)

### Introduction

This project is comprised of two parts. The first part, `freelib-resources`, contains [Checkstyle](http://maven.apache.org/plugins/maven-checkstyle-plugin/) configuration files, Code Formatter settings for Eclipse, PMD rules, etc. The second part, `freelib-parent`, contains a set of dependencies, plugins, and other configuration options to simplify the creation of new Maven projects. The second part also makes using the first's resources much easier because it pulls them in and uses them by default when a new project is configured.

### Using this project

Projects wanting to take advantage of `freelib-build-tools`' simplified configuration options can configure `freelib-parent` as their project's parent. To do this, add the following as the last element in the POM's root element:

    <parent>
      <groupId>info.freelibrary</groupId>
      <artifactId>freelib-parent</artifactId>
      <version>8.0.9</version>
    </parent>

Once this is done, all the configuration options in `freelib-parent`, including the resources from `freelib-resources`, will be available to the project. One can add them to the child project simply by referencing the plugins, etc., defined in the parent project. To see an example of how this is done, see [freelib-utils](https://github.com/ksclarke/freelib-utils)'s POM file.

Note that freelib-build-tools is primarily intended for FreeLibrary projects so some things may not be generally useful to other projects (e.g. Javadoc CSS files). Even if one does not use the freelib-build-tools project directly, there may be some tricks, tools, and conventions here that will prove useful in the creation of one's own "build tools" project.

### Deploying with freelib-build-tools

This project now uses the [action-maven-publish](https://github.com/marketplace/actions/action-maven-publish) GitHub Action. When I switched from using Travis to GitHub Actions, I found this Action, and since it does everything my bespoke release scripts were doing, I dumped my scripts and started using it instead. The Action's author has a [Deployment Setup](https://github.com/samuelmeuli/action-maven-publish/blob/master/docs/deployment-setup.md) guide that you can use to take advantage of this project's Action configurations if you want.

There are several build variables that can be set as Secrets in your project's GitHub configuration:

Secret and value                   | Optional
-----------------------------------|------------------------------------
MAVEN_CACHE_KEY="[string]"         | yes
AUTORELEASE_ARTIFACT="[boolean]"   | yes
SKIP_JAR_DEPLOYMENT="[boolean]"    | yes
AUTO_PR_APPROVAL="[boolean]"       | yes
BUILD_PROFILES="[string]"          | yes
BUILD_PROPERTIES="[string]"        | yes
SONATYPE_USERNAME="[string]"       | when using SKIP_JAR_DEPLOYMENT
SONATYPE_PASSWORD="[string]"       | when using SKIP_JAR_DEPLOYMENT
BUILD_PASSPHRASE="[string]"        | when using SKIP_JAR_DEPLOYMENT
BUILD_KEY="[string]"               | when using SKIP_JAR_DEPLOYMENT
ACTIONS_PAT="[token]"              | only required when using dependabot
DOCKER_REGISTRY_ACCOUNT="[string]" | only required when using Docker
DOCKER_USERNAME="[string]"         | only required when using Docker
DOCKER_PASSWORD="[string]"         | only required when using Docker

If you put any secret values in the BUILD_PROPERTIES variable, you also want to add individual Secrets for those so that GitHub Actions recognizes they should not be displayed in the logs. This is a bit kludgey, but is my current workaround for having a generic Action and no support for string templates in the Maven Action.

When running a build of a project that extends freelib-build-tools, a new `.github` directory will be created in the project's root. Currently, this initialization overwrites any existing Action files with the same names. So, keep that in mind before you start using freelib-build-tools.

### Testing Project's GitHub Actions

This project uses Nektos' [Act](https://github.com/nektos/act) to test GitHub Actions locally. Act spins up a local container with the GitHub Actions environment and runs the GitHub Action in that container. For instance, to run the freelib-build-tools release Action, one would type:

    act "release" -e freelib-resources/src/test/resources/event.json

When Act is run, it uses the `.actrc` file in this project's directory. That file references a `/etc/github/actions/secrets` file, in which environmental variables should be defined. The variables to include in this file are the same ones you'd configure as secrets when deploying on GitHub Actions.

*Note:* Since updating to using commit hashes in this project's GitHub Actions, running `act` no longer works. I've submitted a ticket to request that hashes be supported.

### Contact Information

If you notice something that is broken or that needs fixing, please submit a ticket to the project's [issues queue](https://github.com/ksclarke/freelib-build-tools/issues). If you have a question or a general comment about the project, please use the project's [discussion board](https://github.com/ksclarke/freelib-build-tools/discussions).

Thanks for your interest in this project!
