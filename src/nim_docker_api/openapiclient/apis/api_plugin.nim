#
# Docker Engine API
# 
# The Engine API is an HTTP API served by Docker Engine. It is the API the Docker client uses to communicate with the Engine, so everything the Docker client can do can be done with the API.  Most of the client's commands map directly to API endpoints (e.g. `docker ps` is `GET /containers/json`). The notable exception is running containers, which consists of several API calls.  # Errors  The API uses standard HTTP status codes to indicate the success or failure of the API call. The body of the response will be JSON in the following format:  ``` {   \"message\": \"page not found\" } ```  # Versioning  The API is usually changed in each release, so API calls are versioned to ensure that clients don't break. To lock to a specific version of the API, you prefix the URL with its version, for example, call `/v1.30/info` to use the v1.30 version of the `/info` endpoint. If the API version specified in the URL is not supported by the daemon, a HTTP `400 Bad Request` error message is returned.  If you omit the version-prefix, the current version of the API (v1.41) is used. For example, calling `/info` is the same as calling `/v1.41/info`. Using the API without a version-prefix is deprecated and will be removed in a future release.  Engine releases in the near future should support this version of the API, so your client will continue to work even if it is talking to a newer Engine.  The API uses an open schema model, which means server may add extra properties to responses. Likewise, the server will ignore any extra query parameters and request body properties. When you write clients, you need to ignore additional properties in responses to ensure they do not break when talking to newer daemons.   # Authentication  Authentication for registries is handled client side. The client has to send authentication details to various endpoints that need to communicate with registries, such as `POST /images/(name)/push`. These are sent as `X-Registry-Auth` header as a [base64url encoded](https://tools.ietf.org/html/rfc4648#section-5) (JSON) string with the following structure:  ``` {   \"username\": \"string\",   \"password\": \"string\",   \"email\": \"string\",   \"serveraddress\": \"string\" } ```  The `serveraddress` is a domain/IP without a protocol. Throughout this structure, double quotes are required.  If you have already got an identity token from the [`/auth` endpoint](#operation/SystemAuth), you can just pass this instead of credentials:  ``` {   \"identitytoken\": \"9cbaf023786cd7...\" } ``` 
# The version of the OpenAPI document: 1.41
# 
# Generated by: https://openapi-generator.tech
#

import httpclient
import jsony
import ../utils
import options
import strformat
import strutils
import typetraits
import uri

import ../models/model_plugin
import ../models/model_plugin_privilege

import asyncdispatch


proc getPluginPrivileges*(docker: Docker | AsyncDocker, remote: string): Future[seq[PluginPrivilege]] {.multiSync.} =
  ## Get plugin privileges
  let query_for_api_call = encodeQuery([
    ("remote", $remote), # The name of the plugin. The `:latest` tag is optional, and is the default if omitted. 
  ])

  let response = await docker.client.request(docker.basepath & "/plugins/privileges" & "?" & query_for_api_call, HttpMethod.HttpGet)
  return await constructResult1[seq[PluginPrivilege]](response)


proc pluginCreate*(docker: Docker | AsyncDocker, name: string, tarContext: string): Future[Response | AsyncResponse] {.multiSync.} =
  ## Create a plugin
  docker.client.headers["Content-Type"] = "application/json"
  let query_for_api_call = encodeQuery([
    ("name", $name), # The name of the plugin. The `:latest` tag is optional, and is the default if omitted. 
  ])
  return await docker.client.request(docker.basepath & "/plugins/create" & "?" & query_for_api_call, HttpMethod.HttpPost, tarContext.toJson())


proc pluginDelete*(docker: Docker | AsyncDocker, name: string, force: bool): Future[Plugin] {.multiSync.} =
  ## Remove a plugin
  let query_for_api_call = encodeQuery([
    ("force", $force), # Disable the plugin before removing. This may result in issues if the plugin is in use by a container. 
  ])

  let response = await docker.client.request(docker.basepath & fmt"/plugins/{name}" & "?" & query_for_api_call, HttpMethod.HttpDelete)
  return await constructResult1[Plugin](response)


proc pluginDisable*(docker: Docker | AsyncDocker, name: string): Future[Response | AsyncResponse] {.multiSync.} =
  ## Disable a plugin
  return await docker.client.request(docker.basepath & fmt"/plugins/{name}/disable", HttpMethod.HttpPost)


proc pluginEnable*(docker: Docker | AsyncDocker, name: string, timeout: int): Future[Response | AsyncResponse] {.multiSync.} =
  ## Enable a plugin
  let query_for_api_call = encodeQuery([
    ("timeout", $timeout), # Set the HTTP client timeout (in seconds)
  ])
  return await docker.client.request(docker.basepath & fmt"/plugins/{name}/enable" & "?" & query_for_api_call, HttpMethod.HttpPost)


proc pluginInspect*(docker: Docker | AsyncDocker, name: string): Future[Plugin] {.multiSync.} =
  ## Inspect a plugin

  let response = await docker.client.request(docker.basepath & fmt"/plugins/{name}/json", HttpMethod.HttpGet)
  return await constructResult1[Plugin](response)


proc pluginList*(docker: Docker | AsyncDocker, filters: string): Future[seq[Plugin]] {.multiSync.} =
  ## List plugins
  let query_for_api_call = encodeQuery([
    ("filters", $filters), # A JSON encoded value of the filters (a `map[string][]string`) to process on the plugin list.  Available filters:  - `capability=<capability name>` - `enable=<true>|<false>` 
  ])

  let response = await docker.client.request(docker.basepath & "/plugins" & "?" & query_for_api_call, HttpMethod.HttpGet)
  return await constructResult1[seq[Plugin]](response)


proc pluginPull*(docker: Docker | AsyncDocker, remote: string, name: string, xRegistryAuth: string, body: seq[PluginPrivilege]): Future[Response | AsyncResponse] {.multiSync.} =
  ## Install a plugin
  docker.client.headers["Content-Type"] = "application/json"
  docker.client.headers["X-Registry-Auth"] = xRegistryAuth
  let query_for_api_call = encodeQuery([
    ("remote", $remote), # Remote reference for plugin to install.  The `:latest` tag is optional, and is used as the default if omitted. 
    ("name", $name), # Local name for the pulled plugin.  The `:latest` tag is optional, and is used as the default if omitted. 
  ])
  return await docker.client.request(docker.basepath & "/plugins/pull" & "?" & query_for_api_call, HttpMethod.HttpPost, body.toJson())


proc pluginPush*(docker: Docker | AsyncDocker, name: string): Future[Response | AsyncResponse] {.multiSync.} =
  ## Push a plugin
  return await docker.client.request(docker.basepath & fmt"/plugins/{name}/push", HttpMethod.HttpPost)


proc pluginSet*(docker: Docker | AsyncDocker, name: string, body: seq[string]): Future[Response | AsyncResponse] {.multiSync.} =
  ## Configure a plugin
  docker.client.headers["Content-Type"] = "application/json"
  return await docker.client.request(docker.basepath & fmt"/plugins/{name}/set", HttpMethod.HttpPost, body.toJson())


proc pluginUpgrade*(docker: Docker | AsyncDocker, name: string, remote: string, xRegistryAuth: string, body: seq[PluginPrivilege]): Future[Response | AsyncResponse] {.multiSync.} =
  ## Upgrade a plugin
  docker.client.headers["Content-Type"] = "application/json"
  docker.client.headers["X-Registry-Auth"] = xRegistryAuth
  let query_for_api_call = encodeQuery([
    ("remote", $remote), # Remote reference to upgrade to.  The `:latest` tag is optional, and is used as the default if omitted. 
  ])
  return await docker.client.request(docker.basepath & fmt"/plugins/{name}/upgrade" & "?" & query_for_api_call, HttpMethod.HttpPost,  body.toJson())

