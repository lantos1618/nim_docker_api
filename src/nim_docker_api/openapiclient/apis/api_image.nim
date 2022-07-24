#
# Docker Engine API
# 
# The Engine API is an HTTP API served by Docker Engine. It is the API the Docker client uses to communicate with the Engine, so everything the Docker client can do can be done with the API.  Most of the client's commands map directly to API endpoints (e.g. `docker ps` is `GET /containers/json`). The notable exception is running containers, which consists of several API calls.  # Errors  The API uses standard HTTP status codes to indicate the success or failure of the API call. The body of the response will be JSON in the following format:  ``` {   \"message\": \"page not found\" } ```  # Versioning  The API is usually changed in each release, so API calls are versioned to ensure that clients don't break. To lock to a specific version of the API, you prefix the URL with its version, for example, call `/v1.30/info` to use the v1.30 version of the `/info` endpoint. If the API version specified in the URL is not supported by the daemon, a HTTP `400 Bad Request` error message is returned.  If you omit the version-prefix, the current version of the API (v1.41) is used. For example, calling `/info` is the same as calling `/v1.41/info`. Using the API without a version-prefix is deprecated and will be removed in a future release.  Engine releases in the near future should support this version of the API, so your client will continue to work even if it is talking to a newer Engine.  The API uses an open schema model, which means server may add extra properties to responses. Likewise, the server will ignore any extra query parameters and request body properties. When you write clients, you need to ignore additional properties in responses to ensure they do not break when talking to newer daemons.   # Authentication  Authentication for registries is handled client side. The client has to send authentication details to various endpoints that need to communicate with registries, such as `POST /images/(name)/push`. These are sent as `X-Registry-Auth` header as a [base64url encoded](https://tools.ietf.org/html/rfc4648#section-5) (JSON) string with the following structure:  ``` {   \"username\": \"string\",   \"password\": \"string\",   \"email\": \"string\",   \"serveraddress\": \"string\" } ```  The `serveraddress` is a domain/IP without a protocol. Throughout this structure, double quotes are required.  If you have already got an identity token from the [`/auth` endpoint](#operation/SystemAuth), you can just pass this instead of credentials:  ``` {   \"identitytoken\": \"9cbaf023786cd7...\" } ``` 
# The version of the OpenAPI document: 1.41
# 
# Generated by: https://openapi-generator.tech
#

import httpclient
import json
import api_utils
import options
import strformat
import strutils
import tables
import typetraits
import uri

import ../models/model_build_prune_response
import ../models/model_container_config
import ../models/model_history_response_item
import ../models/model_id_response
import ../models/model_image_delete_response_item
import ../models/model_image_inspect
import ../models/model_image_prune_response
import ../models/model_image_search_response_item
import ../models/model_image_summary

import asyncdispatch


proc buildPrune*(docker: Docker | AsyncDocker, keepStorage: int64, all: bool, filters: string): Future[BuildPruneResponse] {.multiSync.} =
  ## Delete builder cache
  let query_for_api_call = encodeQuery([
    ("keep-storage", $keepStorage), # Amount of disk space in bytes to keep for cache
    ("all", $all), # Remove all types of build cache
    ("filters", $filters), # A JSON encoded value of the filters (a `map[string][]string`) to process on the list of build cache objects.  Available filters:  - `until=<duration>`: duration relative to daemon's time, during which build cache was not used, in Go's duration format (e.g., '24h') - `id=<id>` - `parent=<id>` - `type=<string>` - `description=<string>` - `inuse` - `shared` - `private` 
  ])

  let response = await docker.client.post(docker.basepath & "/build/prune" & "?" & query_for_api_call)
  return await constructResult1[BuildPruneResponse](response)


proc imageBuild*(docker: Docker | AsyncDocker, dockerfile: string, t: string, extrahosts: string, remote: string, q: bool, nocache: bool, cachefrom: string, pull: string, rm: bool, forcerm: bool, memory: int, memswap: int, cpushares: int, cpusetcpus: string, cpuperiod: int, cpuquota: int, buildargs: string, shmsize: int, squash: bool, labels: string, networkmode: string, contentType: string, xRegistryConfig: string, platform: string, target: string, outputs: string, inputStream: string): Response =
  ## Build an image
  docker.client.headers["Content-Type"] = "application/json"
  docker.client.headers["Content-type"] = contentType
  docker.client.headers["X-Registry-Config"] = xRegistryConfig
  let query_for_api_call = encodeQuery([
    ("dockerfile", $dockerfile), # Path within the build context to the `Dockerfile`. This is ignored if `remote` is specified and points to an external `Dockerfile`.
    ("t", $t), # A name and optional tag to apply to the image in the `name:tag` format. If you omit the tag the default `latest` value is assumed. You can provide several `t` parameters.
    ("extrahosts", $extrahosts), # Extra hosts to add to /etc/hosts
    ("remote", $remote), # A Git repository URI or HTTP/HTTPS context URI. If the URI points to a single text file, the file’s contents are placed into a file called `Dockerfile` and the image is built from that file. If the URI points to a tarball, the file is downloaded by the daemon and the contents therein used as the context for the build. If the URI points to a tarball and the `dockerfile` parameter is also specified, there must be a file with the corresponding path inside the tarball.
    ("q", $q), # Suppress verbose build output.
    ("nocache", $nocache), # Do not use the cache when building the image.
    ("cachefrom", $cachefrom), # JSON array of images used for build cache resolution.
    ("pull", $pull), # Attempt to pull the image even if an older image exists locally.
    ("rm", $rm), # Remove intermediate containers after a successful build.
    ("forcerm", $forcerm), # Always remove intermediate containers, even upon failure.
    ("memory", $memory), # Set memory limit for build.
    ("memswap", $memswap), # Total memory (memory + swap). Set as `-1` to disable swap.
    ("cpushares", $cpushares), # CPU shares (relative weight).
    ("cpusetcpus", $cpusetcpus), # CPUs in which to allow execution (e.g., `0-3`, `0,1`).
    ("cpuperiod", $cpuperiod), # The length of a CPU period in microseconds.
    ("cpuquota", $cpuquota), # Microseconds of CPU time that the container can get in a CPU period.
    ("buildargs", $buildargs), # JSON map of string pairs for build-time variables. Users pass these values at build-time. Docker uses the buildargs as the environment context for commands run via the `Dockerfile` RUN instruction, or for variable expansion in other `Dockerfile` instructions. This is not meant for passing secret values.  For example, the build arg `FOO=bar` would become `{\"FOO\":\"bar\"}` in JSON. This would result in the query parameter `buildargs={\"FOO\":\"bar\"}`. Note that `{\"FOO\":\"bar\"}` should be URI component encoded.  [Read more about the buildargs instruction.](/engine/reference/builder/#arg) 
    ("shmsize", $shmsize), # Size of `/dev/shm` in bytes. The size must be greater than 0. If omitted the system uses 64MB.
    ("squash", $squash), # Squash the resulting images layers into a single layer. *(Experimental release only.)*
    ("labels", $labels), # Arbitrary key/value labels to set on the image, as a JSON map of string pairs.
    ("networkmode", $networkmode), # Sets the networking mode for the run commands during build. Supported standard values are: `bridge`, `host`, `none`, and `container:<name|id>`. Any other value is taken as a custom network's name or ID to which this container should connect to. 
    ("platform", $platform), # Platform in the format os[/arch[/variant]]
    ("target", $target), # Target build stage
    ("outputs", $outputs), # BuildKit output configuration
  ])
  await docker.client.post(docker.basepath & "/build" & "?" & query_for_api_call, $(%inputStream))


proc imageCommit*(docker: Docker | AsyncDocker, container: string, repo: string, tag: string, comment: string, author: string, pause: bool, changes: string, containerConfig: ContainerConfig): Future[IdResponse] {.multiSync.} =
  ## Create a new image from a container
  docker.client.headers["Content-Type"] = "application/json"
  let query_for_api_call = encodeQuery([
    ("container", $container), # The ID or name of the container to commit
    ("repo", $repo), # Repository name for the created image
    ("tag", $tag), # Tag name for the create image
    ("comment", $comment), # Commit message
    ("author", $author), # Author of the image (e.g., `John Hannibal Smith <hannibal@a-team.com>`)
    ("pause", $pause), # Whether to pause the container before committing
    ("changes", $changes), # `Dockerfile` instructions to apply while committing
  ])

  let response = await docker.client.post(docker.basepath & "/commit" & "?" & query_for_api_call, $(%containerConfig))
  return await constructResult1[IdResponse](response)


proc imageCreate*(docker: Docker | AsyncDocker, fromImage: string, fromSrc: string, repo: string, tag: string, message: string, xRegistryAuth: string, changes: seq[string], platform: string, inputImage: string): Response =
  ## Create an image
  docker.client.headers["Content-Type"] = "application/json"
  docker.client.headers["X-Registry-Auth"] = xRegistryAuth
  let query_for_api_call = encodeQuery([
    ("fromImage", $fromImage), # Name of the image to pull. The name may include a tag or digest. This parameter may only be used when pulling an image. The pull is cancelled if the HTTP connection is closed.
    ("fromSrc", $fromSrc), # Source to import. The value may be a URL from which the image can be retrieved or `-` to read the image from the request body. This parameter may only be used when importing an image.
    ("repo", $repo), # Repository name given to an image when it is imported. The repo may include a tag. This parameter may only be used when importing an image.
    ("tag", $tag), # Tag or digest. If empty when pulling an image, this causes all tags for the given image to be pulled.
    ("message", $message), # Set commit message for imported image.
    ("changes", $changes.join(",")), # Apply `Dockerfile` instructions to the image that is created, for example: `changes=ENV DEBUG=true`. Note that `ENV DEBUG=true` should be URI component encoded.  Supported `Dockerfile` instructions: `CMD`|`ENTRYPOINT`|`ENV`|`EXPOSE`|`ONBUILD`|`USER`|`VOLUME`|`WORKDIR` 
    ("platform", $platform), # Platform in the format os[/arch[/variant]]
  ])
  await docker.client.post(docker.basepath & "/images/create" & "?" & query_for_api_call, $(%inputImage))


proc imageDelete*(docker: Docker | AsyncDocker, name: string, force: bool, noprune: bool): Future[seq[ImageDeleteResponseItem]] {.multiSync.} =
  ## Remove an image
  let query_for_api_call = encodeQuery([
    ("force", $force), # Remove the image even if it is being used by stopped containers or has other tags
    ("noprune", $noprune), # Do not delete untagged parent images
  ])

  let response = await docker.client.delete(docker.basepath & fmt"/images/{name}" & "?" & query_for_api_call)
  return await constructResult1[seq[ImageDeleteResponseItem]](response)


proc imageGet*(docker: Docker | AsyncDocker, name: string): Future[string] {.multiSync.} =
  ## Export an image

  let response = await docker.client.get(docker.basepath & fmt"/images/{name}/get")
  return await constructResult1[string](response)


proc imageGetAll*(docker: Docker | AsyncDocker, names: seq[string]): Future[string] {.multiSync.} =
  ## Export several images
  let query_for_api_call = encodeQuery([
    ("names", $names.join(",")), # Image names to filter by
  ])

  let response = await docker.client.get(docker.basepath & "/images/get" & "?" & query_for_api_call)
  return await constructResult1[string](response)


proc imageHistory*(docker: Docker | AsyncDocker, name: string): Future[seq[HistoryResponseItem]] {.multiSync.} =
  ## Get the history of an image

  let response = await docker.client.get(docker.basepath & fmt"/images/{name}/history")
  return await constructResult1[seq[HistoryResponseItem]](response)


proc imageInspect*(docker: Docker | AsyncDocker, name: string): Future[ImageInspect] {.multiSync.} =
  ## Inspect an image

  let response = await docker.client.get(docker.basepath & fmt"/images/{name}/json")
  return await constructResult1[ImageInspect](response)


proc imageList*(docker: Docker | AsyncDocker, all: bool, filters: string, digests: bool): Future[seq[ImageSummary]] {.multiSync.} =
  ## List Images
  let query_for_api_call = encodeQuery([
    ("all", $all), # Show all images. Only images from a final layer (no children) are shown by default.
    ("filters", $filters), # A JSON encoded value of the filters (a `map[string][]string`) to process on the images list.  Available filters:  - `before`=(`<image-name>[:<tag>]`,  `<image id>` or `<image@digest>`) - `dangling=true` - `label=key` or `label=\"key=value\"` of an image label - `reference`=(`<image-name>[:<tag>]`) - `since`=(`<image-name>[:<tag>]`,  `<image id>` or `<image@digest>`) 
    ("digests", $digests), # Show digest information as a `RepoDigests` field on each image.
  ])

  let response = await docker.client.get(docker.basepath & "/images/json" & "?" & query_for_api_call)
  return await constructResult1[seq[ImageSummary]](response)


proc imageLoad*(docker: Docker | AsyncDocker, quiet: bool, imagesTarball: string): Response =
  # images
  docker.client.headers["Content-Type"] = "application/json"
  let query_for_api_call = encodeQuery([
    ("quiet", $quiet), # Suppress progress details during load.
  ])
  await docker.client.post(docker.basepath & "/images/load" & "?" & query_for_api_call, $(%imagesTarball))


proc imagePrune*(docker: Docker | AsyncDocker, filters: string): Future[ImagePruneResponse] {.multiSync.} =
  ## Delete unused images
  let query_for_api_call = encodeQuery([
    ("filters", $filters), # Filters to process on the prune list, encoded as JSON (a `map[string][]string`). Available filters:  - `dangling=<boolean>` When set to `true` (or `1`), prune only    unused *and* untagged images. When set to `false`    (or `0`), all unused images are pruned. - `until=<string>` Prune images created before this timestamp. The `<timestamp>` can be Unix timestamps, date formatted timestamps, or Go duration strings (e.g. `10m`, `1h30m`) computed relative to the daemon machine’s time. - `label` (`label=<key>`, `label=<key>=<value>`, `label!=<key>`, or `label!=<key>=<value>`) Prune images with (or without, in case `label!=...` is used) the specified labels. 
  ])

  let response = await docker.client.post(docker.basepath & "/images/prune" & "?" & query_for_api_call)
  return await constructResult1[ImagePruneResponse](response)


proc imagePush*(docker: Docker | AsyncDocker, name: string, xRegistryAuth: string, tag: string): Response =
  ## Push an image
  docker.client.headers["X-Registry-Auth"] = xRegistryAuth
  let query_for_api_call = encodeQuery([
    ("tag", $tag), # The tag to associate with the image on the registry.
  ])
  await docker.client.post(docker.basepath & fmt"/images/{name}/push" & "?" & query_for_api_call)


proc imageSearch*(docker: Docker | AsyncDocker, term: string, limit: int, filters: string): Future[seq[ImageSearchResponseItem]] {.multiSync.} =
  ## Search images
  let query_for_api_call = encodeQuery([
    ("term", $term), # Term to search
    ("limit", $limit), # Maximum number of results to return
    ("filters", $filters), # A JSON encoded value of the filters (a `map[string][]string`) to process on the images list. Available filters:  - `is-automated=(true|false)` - `is-official=(true|false)` - `stars=<number>` Matches images that has at least 'number' stars. 
  ])

  let response = await docker.client.get(docker.basepath & "/images/search" & "?" & query_for_api_call)
  return await constructResult1[seq[ImageSearchResponseItem]](response)


proc imageTag*(docker: Docker | AsyncDocker, name: string, repo: string, tag: string): Response =
  ## Tag an image
  let query_for_api_call = encodeQuery([
    ("repo", $repo), # The repository to tag in. For example, `someuser/someimage`.
    ("tag", $tag), # The name of the new tag.
  ])
  await docker.client.post(docker.basepath & fmt"/images/{name}/tag" & "?" & query_for_api_call)

