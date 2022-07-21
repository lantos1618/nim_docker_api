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
# import logging
# import marshal
import jsony
import api_utils
import options
import strformat
import strutils
import tables
import typetraits
import uri

import ../models/model_container_change_response_item
import ../models/model_container_create_response
import ../models/model_container_create_request
import ../models/model_container_inspect_response
import ../models/model_container_prune_response
import ../models/model_container_summary
import ../models/model_container_top_response
import ../models/model_container_update_response
import ../models/model_container_update_request
import ../models/model_container_wait_response
import ../models/model_container_stats
# import ../models/model_error_response
# import ../models/model_object

# const basepath = "http://localhost/v1.41"
const basepath = "unix:///var/run/docker.sock/v1.41"

# template constructResult[T](response: Response): untyped =
#   if response.code in {Http200, Http201, Http202, Http204, Http206}:
#     try:
#       when name(stripGenericParams(T.typedesc).typedesc) == name(Table):
#         (some(json.to(parseJson(response.body), T.typedesc)), response)
#       else:
#         (some(marshal.to[T](response.body)), response)
#     except JsonParsingError:
#       # The server returned a malformed response though the response code is 2XX
#       # TODO: need better error handling
#       error("JsonParsingError")
#       (none(T.typedesc), response)
#   else:
#     (none(T.typedesc), response)


proc containerArchive*(httpClient: HttpClient, id: string, path: string): Response =
  ## Get an archive of a filesystem resource in a container
  let query_for_api_call = encodeQuery([
    ("path", $path), # Resource in the container’s filesystem to archive.
  ])
  httpClient.get(basepath & fmt"/containers/{id}/archive" & "?" & query_for_api_call)


proc containerArchiveInfo*(httpClient: HttpClient, id: string, path: string): Response =
  ## Get information about files in a container
  let query_for_api_call = encodeQuery([
    ("path", $path), # Resource in the container’s filesystem to archive.
  ])
  httpClient.head(basepath & fmt"/containers/{id}/archive" & "?" & query_for_api_call)


proc containerAttach*(httpClient: HttpClient, id: string, detachKeys: string, logs: bool, stream: bool, stdin: bool, stdout: bool, stderr: bool): Response =
  ## Attach to a container
  let query_for_api_call = encodeQuery([
    ("detachKeys", $detachKeys), # Override the key sequence for detaching a container.Format is a single character `[a-Z]` or `ctrl-<value>` where `<value>` is one of: `a-z`, `@`, `^`, `[`, `,` or `_`. 
    ("logs", $logs), # Replay previous logs from the container.  This is useful for attaching to a container that has started and you want to output everything since the container started.  If `stream` is also enabled, once all the previous output has been returned, it will seamlessly transition into streaming current output. 
    ("stream", $stream), # Stream attached streams from the time the request was made onwards. 
    ("stdin", $stdin), # Attach to `stdin`
    ("stdout", $stdout), # Attach to `stdout`
    ("stderr", $stderr), # Attach to `stderr`
  ])
  httpClient.post(basepath & fmt"/containers/{id}/attach" & "?" & query_for_api_call)


proc containerAttachWebsocket*(httpClient: HttpClient, id: string, detachKeys: string, logs: bool, stream: bool): Response =
  ## Attach to a container via a websocket
  let query_for_api_call = encodeQuery([
    ("detachKeys", $detachKeys), # Override the key sequence for detaching a container.Format is a single character `[a-Z]` or `ctrl-<value>` where `<value>` is one of: `a-z`, `@`, `^`, `[`, `,`, or `_`. 
    ("logs", $logs), # Return logs
    ("stream", $stream), # Return stream
  ])
  httpClient.get(basepath & fmt"/containers/{id}/attach/ws" & "?" & query_for_api_call)


proc containerChanges*(httpClient: HttpClient, id: string): (Option[seq[ContainerChangeResponseItem]], Response) =
  ## Get changes on a container’s filesystem

  let response = httpClient.get(basepath & fmt"/containers/{id}/changes")
  constructResult[seq[ContainerChangeResponseItem]](response)


proc containerCreate*(httpClient: HttpClient, body: ContainerCreateRequest, name: string): (Option[ContainerCreateResponse], Response) =
  ## Create a container
  httpClient.headers["Content-Type"] = "application/json"
  let query_for_api_call = encodeQuery([
    ("name", $name), # Assign the specified name to the container. Must match `/?[a-zA-Z0-9][a-zA-Z0-9_.-]+`. 
  ])

  let response = httpClient.post(basepath & "/containers/create" & "?" & query_for_api_call, $(%body))
  constructResult[ContainerCreateResponse](response)


proc containerDelete*(httpClient: HttpClient, id: string, v: bool, force: bool, link: bool): Response =
  ## Remove a container
  let query_for_api_call = encodeQuery([
    ("v", $v), # Remove anonymous volumes associated with the container.
    ("force", $force), # If the container is running, kill it before removing it.
    ("link", $link), # Remove the specified link associated with the container.
  ])
  httpClient.delete(basepath & fmt"/containers/{id}" & "?" & query_for_api_call)


proc containerExport*(httpClient: HttpClient, id: string): Response =
  ## Export a container
  httpClient.get(basepath & fmt"/containers/{id}/export")


proc containerInspect*(httpClient: HttpClient, id: string, size: bool): (Option[ContainerInspectResponse], Response) =
  ## Inspect a container
  let query_for_api_call = encodeQuery([
    ("size", $size), # Return the size of container as fields `SizeRw` and `SizeRootFs`
  ])

  let response = httpClient.get(basepath & fmt"/containers/{id}/json" & "?" & query_for_api_call)
  constructResult[ContainerInspectResponse](response)


proc containerKill*(httpClient: HttpClient, id: string, signal: string): Response =
  ## Kill a container
  let query_for_api_call = encodeQuery([
    ("signal", $signal), # Signal to send to the container as an integer or string (e.g. `SIGINT`)
  ])
  httpClient.post(basepath & fmt"/containers/{id}/kill" & "?" & query_for_api_call)


proc containerList*(httpClient: HttpClient, all: bool = false, limit: Option[int] = none(int), size: bool = false, filters: Option[Table[string, seq[string]]] = none(Table[string, seq[string]])): (Option[seq[ContainerSummary]], Response) =
  ## List containers
  let query_for_api_call = encodeQuery([
    ("all", $all), # Return all containers. By default, only running containers are shown. 
    ("limit", limit), # Return this number of most recently created containers, including non-running ones. 
    ("size", $size), # Return the size of container as fields `SizeRw` and `SizeRootFs`. 
    ("filters", filters.toJson()), # Filters to process on the container list, encoded as JSON (a `map[string][]string`). For example, `{\"status\": [\"paused\"]}` will only return paused containers.  Available filters:  - `ancestor`=(`<image-name>[:<tag>]`, `<image id>`, or `<image@digest>`) - `before`=(`<container id>` or `<container name>`) - `expose`=(`<port>[/<proto>]`|`<startport-endport>/[<proto>]`) - `exited=<int>` containers with exit code of `<int>` - `health`=(`starting`|`healthy`|`unhealthy`|`none`) - `id=<ID>` a container's ID - `isolation=`(`default`|`process`|`hyperv`) (Windows daemon only) - `is-task=`(`true`|`false`) - `label=key` or `label=\"key=value\"` of a container label - `name=<name>` a container's name - `network`=(`<network id>` or `<network name>`) - `publish`=(`<port>[/<proto>]`|`<startport-endport>/[<proto>]`) - `since`=(`<container id>` or `<container name>`) - `status=`(`created`|`restarting`|`running`|`removing`|`paused`|`exited`|`dead`) - `volume`=(`<volume name>` or `<mount point destination>`) 
  ])

  let response = httpClient.get(basepath & "/containers/json" & "?" & query_for_api_call)
  echo httpClient.headers
  echo response.body()

  constructResult[seq[ContainerSummary]](response)


proc containerLogs*(httpClient: HttpClient, id: string, follow: bool, stdout: bool, stderr: bool, since: int, until: int, timestamps: bool, tail: string): (Option[string], Response) =
  ## Get container logs
  let query_for_api_call = encodeQuery([
    ("follow", $follow), # Keep connection after returning logs.
    ("stdout", $stdout), # Return logs from `stdout`
    ("stderr", $stderr), # Return logs from `stderr`
    ("since", $since), # Only return logs since this time, as a UNIX timestamp
    ("until", $until), # Only return logs before this time, as a UNIX timestamp
    ("timestamps", $timestamps), # Add timestamps to every log line
    ("tail", $tail), # Only return this number of log lines from the end of the logs. Specify as an integer or `all` to output all log lines. 
  ])

  let response = httpClient.get(basepath & fmt"/containers/{id}/logs" & "?" & query_for_api_call)
  constructResult[string](response)


proc containerPause*(httpClient: HttpClient, id: string): Response =
  ## Pause a container
  httpClient.post(basepath & fmt"/containers/{id}/pause")


proc containerPrune*(httpClient: HttpClient, filters: string): (Option[ContainerPruneResponse], Response) =
  ## Delete stopped containers
  let query_for_api_call = encodeQuery([
    ("filters", $filters), # Filters to process on the prune list, encoded as JSON (a `map[string][]string`).  Available filters: - `until=<timestamp>` Prune containers created before this timestamp. The `<timestamp>` can be Unix timestamps, date formatted timestamps, or Go duration strings (e.g. `10m`, `1h30m`) computed relative to the daemon machine’s time. - `label` (`label=<key>`, `label=<key>=<value>`, `label!=<key>`, or `label!=<key>=<value>`) Prune containers with (or without, in case `label!=...` is used) the specified labels. 
  ])

  let response = httpClient.post(basepath & "/containers/prune" & "?" & query_for_api_call)
  constructResult[ContainerPruneResponse](response)


proc containerRename*(httpClient: HttpClient, id: string, name: string): Response =
  ## Rename a container
  let query_for_api_call = encodeQuery([
    ("name", $name), # New name for the container
  ])
  httpClient.post(basepath & fmt"/containers/{id}/rename" & "?" & query_for_api_call)


proc containerResize*(httpClient: HttpClient, id: string, h: int, w: int): Response =
  ## Resize a container TTY
  let query_for_api_call = encodeQuery([
    ("h", $h), # Height of the TTY session in characters
    ("w", $w), # Width of the TTY session in characters
  ])
  httpClient.post(basepath & fmt"/containers/{id}/resize" & "?" & query_for_api_call)


proc containerRestart*(httpClient: HttpClient, id: string, t: int): Response =
  ## Restart a container
  let query_for_api_call = encodeQuery([
    ("t", $t), # Number of seconds to wait before killing the container
  ])
  httpClient.post(basepath & fmt"/containers/{id}/restart" & "?" & query_for_api_call)


proc containerStart*(httpClient: HttpClient, id: string, detachKeys: string): Response =
  ## Start a container
  let query_for_api_call = encodeQuery([
    ("detachKeys", $detachKeys), # Override the key sequence for detaching a container. Format is a single character `[a-Z]` or `ctrl-<value>` where `<value>` is one of: `a-z`, `@`, `^`, `[`, `,` or `_`. 
  ])
  httpClient.post(basepath & fmt"/containers/{id}/start" & "?" & query_for_api_call)


proc containerStats*(httpClient: HttpClient, id: string, stream: bool, oneShot: bool): (Option[ContainerStats], Response) =
  ## Get container stats based on resource usage
  let query_for_api_call = encodeQuery([
    ("stream", $stream), # Stream the output. If false, the stats will be output once and then it will disconnect. 
    ("one-shot", $oneShot), # Only get a single stat instead of waiting for 2 cycles. Must be used with `stream=false`. 
  ])

  let response = httpClient.get(basepath & fmt"/containers/{id}/stats" & "?" & query_for_api_call)
  constructResult[ContainerStats](response)


proc containerStop*(httpClient: HttpClient, id: string, t: int): Response =
  ## Stop a container
  let query_for_api_call = encodeQuery([
    ("t", $t), # Number of seconds to wait before killing the container
  ])
  httpClient.post(basepath & fmt"/containers/{id}/stop" & "?" & query_for_api_call)


proc containerTop*(httpClient: HttpClient, id: string, psArgs: string): (Option[ContainerTopResponse], Response) =
  ## List processes running inside a container
  let query_for_api_call = encodeQuery([
    ("ps_args", $psArgs), # The arguments to pass to `ps`. For example, `aux`
  ])

  let response = httpClient.get(basepath & fmt"/containers/{id}/top" & "?" & query_for_api_call)
  constructResult[ContainerTopResponse](response)


proc containerUnpause*(httpClient: HttpClient, id: string): Response =
  ## Unpause a container
  httpClient.post(basepath & fmt"/containers/{id}/unpause")


proc containerUpdate*(httpClient: HttpClient, id: string, update: ContainerUpdateRequest): (Option[ContainerUpdateResponse], Response) =
  ## Update a container
  httpClient.headers["Content-Type"] = "application/json"

  let response = httpClient.post(basepath & fmt"/containers/{id}/update", $(%update))
  constructResult[ContainerUpdateResponse](response)


proc containerWait*(httpClient: HttpClient, id: string, condition: string): (Option[ContainerWaitResponse], Response) =
  ## Wait for a container
  let query_for_api_call = encodeQuery([
    ("condition", $condition), # Wait until a container state reaches the given condition.  Defaults to `not-running` if omitted or empty. 
  ])

  let response = httpClient.post(basepath & fmt"/containers/{id}/wait" & "?" & query_for_api_call)
  constructResult[ContainerWaitResponse](response)


proc putContainerArchive*(httpClient: HttpClient, id: string, path: string, inputStream: string, noOverwriteDirNonDir: string, copyUIDGID: string): Response =
  ## Extract an archive of files or folders to a directory in a container
  httpClient.headers["Content-Type"] = "application/json"
  let query_for_api_call = encodeQuery([
    ("path", $path), # Path to a directory in the container to extract the archive’s contents into. 
    ("noOverwriteDirNonDir", $noOverwriteDirNonDir), # If `1`, `true`, or `True` then it will be an error if unpacking the given content would cause an existing directory to be replaced with a non-directory and vice versa. 
    ("copyUIDGID", $copyUIDGID), # If `1`, `true`, then it will copy UID/GID maps to the dest file or dir 
  ])
  httpClient.put(basepath & fmt"/containers/{id}/archive" & "?" & query_for_api_call, $(%inputStream))