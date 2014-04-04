
## Releasing changes

- Bump the version in https://github.com/balanced-cookbooks/balanced-omnibus/blob/master/metadata.rb to an even number for release.
- Tag commit and push changes and tags.
- Upload cookbook with ```knife cookbook upload --freeze -o .. balanced-omnibus```
- Bump the version in https://github.com/balanced-cookbooks/balanced-omnibus/blob/master/metadata.rb to an odd number for dev.
- Push changes

If you need these changes applied faster than chef-client runs on, say, a builder instance, run ```sudo chef-client``` on the instance.
