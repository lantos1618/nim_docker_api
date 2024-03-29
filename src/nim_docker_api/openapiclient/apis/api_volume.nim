#
# Docker Engine API
# 
# The Engine API is an HTTP API served by Docker Engine. It is the API the Docker client uses to communicate with the Engine, so everything the Docker client can do can be done with the API.  Most of the client's commands map directly to API endpoints (e.g. `docker ps` is `GET /containers/json`). The notable exception is running containers, which consists of several API calls.  # Errors  The API uses standard HTTP status codes to indicate the success or failure of the API call. The body of the response will be JSON in the following format:  ``` {   \"message\": \"page not found\" } ```  # Versioning  The API is usually changed in each release, so API calls are versioned to ensure that clients don't break. To lock to a specific version of the API, you prefix the URL with its version, for example, call `/v1.30/info` to use the v1.30 version of the `/info` endpoint. If the API version specified in the URL is not supported by the daemon, a HTTP `400 Bad Request` error message is returned.  If you omit the version-prefix, the current version of the API (v1.41) is used. For example, calling `/info` is the same as calling `/v1.41/info`. Using the API without a version-prefix is deprecated and will be removed in a future release.  Engine releases in the near future should support this version of the API, so your client will continue to work even if it is talking to a newer Engine.  The API uses an open schema model, which means server may add extra properties to responses. Likewise, the server will ignore any extra query parameters and request body properties. When you write clients, you need to ignore additional properties in responses to ensure they do not break when talking to newer daemons.   # Authentication  Authentication for registries is handled client side. The client has to send authentication details to various endpoints that need to communicate with registries, such as `POST /images/(name)/push`. These are sent as `X-Registry-Auth` header as a [base64url encoded](https://tools.ietf.org/html/rfc4648#section-5) (JSON) string with the following structure:  ``` {   \"username\": \"string\",   \"password\": \"string\",   \"email\": \"string\",   \"serveraddress\": \"string\" } ```  The `serveraddress` is a domain/IP without a protocol. Throughout this structure, double quotes are required.  If you have already got an identity token from the [`/auth` endpoint](#operation/SystemAuth), you can just pass this instead of credentials:  ``` {   \"identitytoken\": \"9cbaf023786cd7...\" } ``` 
# The version of the OpenAPI document: 1.41
# 
# Generated by: https://openapi-generator.tech
#

import httpclient
import ../utils
import jsony
import options
import strformat
import strutils
import typetraits
import uri
import asyncdispatch

import ../models/model_volume
import ../models/model_volume_create_options
import ../models/model_volume_list_response
import ../models/model_volume_prune_response



proc volumeCreate*(docker: Docker | AsyncDocker, volumeConfig: VolumeCreateOptions): Future[Volume] {.multiSync.} =
  ## Create a volume
  docker.client.headers["Content-Type"] = "application/json"

  let response = await docker.client.request(docker.basepath & "/volumes/create", HttpMethod.HttpPost, volumeConfig.toJson())
  return await constructResult1[Volume](response)


proc volumeDelete*(docker: Docker | AsyncDocker, name: string, force: bool): Future[Response | AsyncResponse] {.multiSync.} =
  ## Remove a volume
  let query_for_api_call = encodeQuery([
    ("force", $force), # Force the removal of the volume
  ])
  return await docker.client.request(docker.basepath & fmt"/volumes/{name}" & "?" & query_for_api_call, HttpMethod.HttpDelete)


proc volumeInspect*(docker: Docker | AsyncDocker, name: string): Future[Volume] {.multiSync.} =
  ## Inspect a volume

  let response = await docker.client.request(docker.basepath & fmt"/volumes/{name}", HttpMethod.HttpGet)
  return await constructResult1[Volume](response)


proc volumeList*(docker: Docker | AsyncDocker, filters: string): Future[VolumeListResponse] {.multiSync.} =
  ## List volumes
  let query_for_api_call = encodeQuery([
    ("filters", $filters), # JSON encoded value of the filters (a `map[string][]string`) to process on the volumes list. Available filters:  - `dangling=<boolean>` When set to `true` (or `1`), returns all    volumes that are not in use by a container. When set to `false`    (or `0`), only volumes that are in use by one or more    containers are returned. - `driver=<volume-driver-name>` Matches volumes based on their driver. - `label=<key>` or `label=<key>:<value>` Matches volumes based on    the presence of a `label` alone or a `label` and a value. - `name=<volume-name>` Matches all or part of a volume name. 
  ])

  let response = await docker.client.request(docker.basepath & "/volumes" & "?" & query_for_api_call, HttpMethod.HttpGet)
  return await constructResult1[VolumeListResponse](response)


proc volumePrune*(docker: Docker | AsyncDocker, filters: string): Future[VolumePruneResponse] {.multiSync.} =
  ## Delete unused volumes
  let query_for_api_call = encodeQuery([
    ("filters", $filters), # Filters to process on the prune list, encoded as JSON (a `map[string][]string`).  Available filters: - `label` (`label=<key>`, `label=<key>=<value>`, `label!=<key>`, or `label!=<key>=<value>`) Prune volumes with (or without, in case `label!=...` is used) the specified labels. 
  ])

  let response = await docker.client.request(docker.basepath & "/volumes/prune" & "?" & query_for_api_call, HttpMethod.HttpPost)
  return await constructResult1[VolumePruneResponse](response)

