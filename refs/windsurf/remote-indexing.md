> ## Documentation Index
> Fetch the complete documentation index at: https://docs.windsurf.com/llms.txt
> Use this file to discover all available pages before exploring further.

# Remote Indexing

> Index remote repositories from GitHub, GitLab, and BitBucket for enterprise teams without storing code locally.

<Note> This feature is only available in the Windsurf Plugins for Enterprise plans. </Note>

While Local Indexing works great, the user may want to index codebases that they do not have stored locally for our models to take in as context.

For this use case, organizations on Teams and Enterprise plans can use Windsurf's Indexing Service to globally import all the relevant repositories. The indexing and embedding is then performed by Windsurf's servers (on an isolated tenant), and once the index is created, it is available to be queried by any member of the Team.

## Adding a repository

From [https://windsurf.com/indexing](https://windsurf.com/indexing) you can add a repository to index. Currently we support Git repositories from GitHub, GitLab, and BitBucket.

<Frame>
  <img src="https://mintcdn.com/codeium/vRt4FQOyBeZpD2Pu/assets/remote-indexing-adding-repo.png?fit=max&auto=format&n=vRt4FQOyBeZpD2Pu&q=85&s=2e60f03d5cddbefc397174c35277273c" data-og-width="2016" width="2016" data-og-height="1488" height="1488" data-path="assets/remote-indexing-adding-repo.png" data-optimize="true" data-opv="3" srcset="https://mintcdn.com/codeium/vRt4FQOyBeZpD2Pu/assets/remote-indexing-adding-repo.png?w=280&fit=max&auto=format&n=vRt4FQOyBeZpD2Pu&q=85&s=706990eab03d43fcfe45bbaf17c94d14 280w, https://mintcdn.com/codeium/vRt4FQOyBeZpD2Pu/assets/remote-indexing-adding-repo.png?w=560&fit=max&auto=format&n=vRt4FQOyBeZpD2Pu&q=85&s=50bc0700ffde8ad79dacc1c3e48307c5 560w, https://mintcdn.com/codeium/vRt4FQOyBeZpD2Pu/assets/remote-indexing-adding-repo.png?w=840&fit=max&auto=format&n=vRt4FQOyBeZpD2Pu&q=85&s=d5e1171d6491c0488d5e856b973b9105 840w, https://mintcdn.com/codeium/vRt4FQOyBeZpD2Pu/assets/remote-indexing-adding-repo.png?w=1100&fit=max&auto=format&n=vRt4FQOyBeZpD2Pu&q=85&s=01231efd308a7ead3b878cd9c003b1ab 1100w, https://mintcdn.com/codeium/vRt4FQOyBeZpD2Pu/assets/remote-indexing-adding-repo.png?w=1650&fit=max&auto=format&n=vRt4FQOyBeZpD2Pu&q=85&s=aa6e287b5569982ca33152b253dc6430 1650w, https://mintcdn.com/codeium/vRt4FQOyBeZpD2Pu/assets/remote-indexing-adding-repo.png?w=2500&fit=max&auto=format&n=vRt4FQOyBeZpD2Pu&q=85&s=4844fcf2cc46856e33bce62e451b9b26 2500w" />
</Frame>

You can choose to index a particular branch and to automatically re-index the repository after some number of days.

## Security Guarantees

We clone the repository in order to create the index, but once we finish creating embeddings for the codebase we delete all the code and code snippets **assuming that the Store Snippets setting is unchecked.** We don't persist anything other than the embeddings themselves, from which you cannot derive the original code.

Furthermore, all indexing and embedding is performed on a single-tenant instance—nothing about the indexing process is shared between multiple Windsurf Teams customers.
