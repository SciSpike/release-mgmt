# Release Management Scripts
This repository contains shell (`sh`) scripts that assist in implementing a release management strategy that is based on one release branch per minor version.
In this strategy, branches are created for each minor version (`vx.y`) and all patches for that release go into its minor branch.

> _TL;DR:_ This is a minor-release-per-branch strategy, and all that the scripts do is create release commits & tags and push so that your CI/CD process can actually perform releases based on branch & tag names.

We currently support release management for
* Helm charts (`release-chart`)
* Docker images released via codefresh.io (`release-image-codefresh`)
* Node.js projects (`release-nodejs`)

Others can be added via copy/paste/massage provided your version information is stored in files.

## Overview
* Source control is assumed to be [git](https://git-scm.com/).
* Version numbers are based on [Semantic Versioning](https://semver.org).
* The prerelease suffix in `master` is `pre` (ie, `1.0.0-pre.0`).
* The prerelease suffix in release branches is `rc` for "release candidate" (ie, `1.0.0-rc.0`).
* The `master` branch always contains the latest & greatest code line.
* The version number in your codebase is almost always at a prerelease level, except for the short amount of time during releases where prerelease suffixes are dropped.
* As you push bugfixes to your minor release branches, assess whether they need to be `git cherry-pick`ed into your `master` branch, or even backported to prior release branches.

## Workflow
* Create your codebase & place it under source control with `git`.
* Set your version to its initial value in the `master` branch.
  * For brand new projects, we recommend `0.1.0-pre.0`.
  * For existing projects, start with a major version greater than `0`, like `1.0.0-pre.0` or whatever you need.
* When you're ready to do your first "alpha", prerelease from `master` with the command `./release-xxx pre` in the `master` branch.
  * This will create tags & commits for your prerelease & push them, whereupon your CI/CD pipeline should kick in and actually perform your release workflow.
* When you're feature complete, but not necessarily bug-free, you can cut your release branch with a "release candidate" from the `master` branch with `./release-xxx rc`.
  * This will create a release branch named `vx.y` where `x` is your `master` branch's current major version and `y` is the minor version.  The initial version in the `vx.y` branch will have the suffix `-rc.0`, which will be released, then it will be immediately bumped to `-rc.1` in preparation for your next release candidate.
  * As you fix bugs in your release candidate, make sure to assess whether they need to be merged back to `master`; `git cherry-pick` is a simple tool with which to do that.
* Continue doing work in `master` for your next minor release, `vx.z` where `z` is `y + 1`.
* When you're sufficiently bug-free in your release branch, you can perform a minor release in that branch with `./release-xxx minor`.
  * This will result in release `vx.y.0`, then bump your prerelease number in the branch to `x.y.1-rc.0`.
  * You can continue fixing bugs in the release branch & possibly merging them back to `master` as you see fit.
  * You can then indefinitely release patches from the release branch with `./release-xxx patch` or prereleases with `./release-xxx rc`.

## Prerequisites or Docker
If you're not going to use the Dockerized versions of these release strategies (meaning the raw scripts), you need to have a Unix-like system with `git` & `docker` installed.
You can even reference the raw script content in your own scripts in order to stay up to date if you'd like to, piping them to `sh` for execution (if you trust doing that):
```
$ \curl -SSL https://raw.githubusercontent.com/SciSpike/release-mgmt/master/release-nodejs | ...`
```

You can also forgo all dependencies except `docker` and use this strategy via Docker containers, as these scripts have been Dockerized under the `scispike` organization on [Docker Hub](https://hub.docker.com).
For example, see https://hub.docker.com/r/scispike/release-nodejs & similar Docker repositories.

```
$ # todo: provide docker invocation example
```
