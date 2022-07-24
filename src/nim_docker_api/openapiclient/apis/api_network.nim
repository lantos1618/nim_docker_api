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
import jsony
import api_utils
import options
import strformat
import strutils
import tables
import typetraits
import uri

import ../models/model_network
import ../models/model_network_connect_request
import ../models/model_network_create_request
import ../models/model_network_create_response
import ../models/model_network_disconnect_request
import ../models/model_network_prune_response

import asyncdispatch


proc networkConnect*(docker: Docker | AsyncDocker, id: string, container: NetworkDisconnectRequest): Response =
  ## Connect a container to a network
  docker.client.headers["Content-Type"] = "application/json"
  await docker.client.post(docker.basepath & fmt"/networks/{id}/connect", $(%container))


proc networkCreate*(docker: Docker | AsyncDocker, networkConfig: NetworkCreateRequest): Future[NetworkCreateResponse] {.multiSync.} =
  ## Create a network
  docker.client.headers["Content-Type"] = "application/json"

  let response = await docker.client.post(docker.basepath & "/networks/create", $(%networkConfig))
  return await constructResult1[NetworkCreateResponse](response)


proc networkDelete*(docker: Docker | AsyncDocker, id: string): Response =
  ## Remove a network
  await docker.client.delete(docker.basepath & fmt"/networks/{id}")


proc networkDisconnect*(docker: Docker | AsyncDocker, id: string, container: NetworkConnectRequest): Response =
  ## Disconnect a container from a network
  docker.client.headers["Content-Type"] = "application/json"
  await docker.client.post(docker.basepath & fmt"/networks/{id}/disconnect", $(%container))


proc networkInspect*(docker: Docker | AsyncDocker, id: string, verbose: bool, scope: string): Future[Network] {.multiSync.} =
  ## Inspect a network
  let query_for_api_call = encodeQuery([
    ("verbose", $verbose), # Detailed inspect output for troubleshooting
    ("scope", $scope), # Filter the network by scope (swarm, global, or local)
  ])

  let response = await docker.client.get(docker.basepath & fmt"/networks/{id}" & "?" & query_for_api_call)
  return await constructResult1[Network](response)


proc networkList*(docker: Docker | AsyncDocker, filters: string): Future[seq[Network]] {.multiSync.} =
  ## List networks
  let query_for_api_call = encodeQuery([
    ("filters", $filters), # JSON encoded value of the filters (a `map[string][]string`) to process on the networks list.  Available filters:  - `dangling=<boolean>` When set to `true` (or `1`), returns all    networks that are not in use by a container. When set to `false`    (or `0`), only networks that are in use by one or more    containers are returned. - `driver=<driver-name>` Matches a network's driver. - `id=<network-id>` Matches all or part of a network ID. - `label=<key>` or `label=<key>=<value>` of a network label. - `name=<network-name>` Matches all or part of a network name. - `scope=[\"swarm\"|\"global\"|\"local\"]` Filters networks by scope (`swarm`, `global`, or `local`). - `type=[\"custom\"|\"builtin\"]` Filters networks by type. The `custom` keyword returns all user-defined networks. 
  ])

  let response = await docker.client.get(docker.basepath & "/networks" & "?" & query_for_api_call)
  return await constructResult1[seq[Network]](response)


proc networkPrune*(docker: Docker | AsyncDocker, filters: string): Future[NetworkPruneResponse] {.multiSync.} =
  ## Delete unused networks
  let query_for_api_call = encodeQuery([
    ("filters", $filters), # Filters to process on the prune list, encoded as JSON (a `map[string][]string`).  Available filters: - `until=<timestamp>` Prune networks created before this timestamp. The `<timestamp>` can be Unix timestamps, date formatted timestamps, or Go duration strings (e.g. `10m`, `1h30m`) computed relative to the daemon machine’s time. - `label` (`label=<key>`, `label=<key>=<value>`, `label!=<key>`, or `label!=<key>=<value>`) Prune networks with (or without, in case `label!=...` is used) the specified labels. 
  ])

  let response = await docker.client.post(docker.basepath & "/networks/prune" & "?" & query_for_api_call)
  return await constructResult1[NetworkPruneResponse](response)

