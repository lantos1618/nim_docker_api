#
# Docker Engine API
# 
# The Engine API is an HTTP API served by Docker Engine. It is the API the Docker client uses to communicate with the Engine, so everything the Docker client can do can be done with the API.  Most of the client's commands map directly to API endpoints (e.g. `docker ps` is `GET /containers/json`). The notable exception is running containers, which consists of several API calls.  # Errors  The API uses standard HTTP status codes to indicate the success or failure of the API call. The body of the response will be JSON in the following format:  ``` {   \"message\": \"page not found\" } ```  # Versioning  The API is usually changed in each release, so API calls are versioned to ensure that clients don't break. To lock to a specific version of the API, you prefix the URL with its version, for example, call `/v1.30/info` to use the v1.30 version of the `/info` endpoint. If the API version specified in the URL is not supported by the daemon, a HTTP `400 Bad Request` error message is returned.  If you omit the version-prefix, the current version of the API (v1.41) is used. For example, calling `/info` is the same as calling `/v1.41/info`. Using the API without a version-prefix is deprecated and will be removed in a future release.  Engine releases in the near future should support this version of the API, so your client will continue to work even if it is talking to a newer Engine.  The API uses an open schema model, which means server may add extra properties to responses. Likewise, the server will ignore any extra query parameters and request body properties. When you write clients, you need to ignore additional properties in responses to ensure they do not break when talking to newer daemons.   # Authentication  Authentication for registries is handled client side. The client has to send authentication details to various endpoints that need to communicate with registries, such as `POST /images/(name)/push`. These are sent as `X-Registry-Auth` header as a [base64url encoded](https://tools.ietf.org/html/rfc4648#section-5) (JSON) string with the following structure:  ``` {   \"username\": \"string\",   \"password\": \"string\",   \"email\": \"string\",   \"serveraddress\": \"string\" } ```  The `serveraddress` is a domain/IP without a protocol. Throughout this structure, double quotes are required.  If you have already got an identity token from the [`/auth` endpoint](#operation/SystemAuth), you can just pass this instead of credentials:  ``` {   \"identitytoken\": \"9cbaf023786cd7...\" } ``` 
# The version of the OpenAPI document: 1.41
# 
# Generated by: https://openapi-generator.tech
#

import httpclient
# import json
# import logging
# import marshal
import jsony
import api_utils
import options
# import strformat
import strutils
import tables
import typetraits
import uri

# import ../models/model_error_response
import ../models/model_swarm
import ../models/model_swarm_init_request
import ../models/model_swarm_join_request
import ../models/model_swarm_spec
import ../models/model_swarm_unlock_request
import ../models/model_unlock_key_response

const basepath = "http://localhost/v1.41"

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


proc swarmInit*(httpClient: HttpClient, body: SwarmInitRequest): (Option[string], Response) =
  ## Initialize a new swarm
  httpClient.headers["Content-Type"] = "application/json"

  # let response = httpClient.post(basepath & "/swarm/init", $(%body))
  let response = httpClient.post(basepath & "/swarm/init", body.toJson())
  constructResult[string](response)


proc swarmInspect*(httpClient: HttpClient): (Option[Swarm], Response) =
  ## Inspect swarm

  let response = httpClient.get(basepath & "/swarm")
  constructResult[Swarm](response)


proc swarmJoin*(httpClient: HttpClient, body: SwarmJoinRequest): Response =
  ## Join an existing swarm
  httpClient.headers["Content-Type"] = "application/json"
  # httpClient.post(basepath & "/swarm/join", $(%body))
  httpClient.post(basepath & "/swarm/join", body.toJson())


proc swarmLeave*(httpClient: HttpClient, force: bool): Response =
  ## Leave a swarm
  let query_for_api_call = encodeQuery([
    ("force", $force), # Force leave swarm, even if this is the last manager or that it will break the cluster. 
  ])
  httpClient.post(basepath & "/swarm/leave" & "?" & query_for_api_call)


proc swarmUnlock*(httpClient: HttpClient, body: SwarmUnlockRequest): Response =
  ## Unlock a locked manager
  httpClient.headers["Content-Type"] = "application/json"
  # httpClient.post(basepath & "/swarm/unlock", $(%body))
  httpClient.post(basepath & "/swarm/unlock", body.toJson())


proc swarmUnlockkey*(httpClient: HttpClient): (Option[UnlockKeyResponse], Response) =
  ## Get the unlock key

  let response = httpClient.get(basepath & "/swarm/unlockkey")
  constructResult[UnlockKeyResponse](response)


proc swarmUpdate*(httpClient: HttpClient, version: int64, body: SwarmSpec, rotateWorkerToken: bool, rotateManagerToken: bool, rotateManagerUnlockKey: bool): Response =
  ## Update a swarm
  httpClient.headers["Content-Type"] = "application/json"
  let query_for_api_call = encodeQuery([
    ("version", $version), # The version number of the swarm object being updated. This is required to avoid conflicting writes. 
    ("rotateWorkerToken", $rotateWorkerToken), # Rotate the worker join token.
    ("rotateManagerToken", $rotateManagerToken), # Rotate the manager join token.
    ("rotateManagerUnlockKey", $rotateManagerUnlockKey), # Rotate the manager unlock key.
  ])
  # httpClient.post(basepath & "/swarm/update" & "?" & query_for_api_call, $(%body))
  httpClient.post(basepath & "/swarm/update" & "?" & query_for_api_call, body.toJson())

