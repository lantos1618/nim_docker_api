#
# Docker Engine API
# 
# The Engine API is an HTTP API served by Docker Engine. It is the API the Docker client uses to communicate with the Engine, so everything the Docker client can do can be done with the API.  Most of the client's commands map directly to API endpoints (e.g. `docker ps` is `GET /containers/json`). The notable exception is running containers, which consists of several API calls.  # Errors  The API uses standard HTTP status codes to indicate the success or failure of the API call. The body of the response will be JSON in the following format:  ``` {   \"message\": \"page not found\" } ```  # Versioning  The API is usually changed in each release, so API calls are versioned to ensure that clients don't break. To lock to a specific version of the API, you prefix the URL with its version, for example, call `/v1.30/info` to use the v1.30 version of the `/info` endpoint. If the API version specified in the URL is not supported by the daemon, a HTTP `400 Bad Request` error message is returned.  If you omit the version-prefix, the current version of the API (v1.41) is used. For example, calling `/info` is the same as calling `/v1.41/info`. Using the API without a version-prefix is deprecated and will be removed in a future release.  Engine releases in the near future should support this version of the API, so your client will continue to work even if it is talking to a newer Engine.  The API uses an open schema model, which means server may add extra properties to responses. Likewise, the server will ignore any extra query parameters and request body properties. When you write clients, you need to ignore additional properties in responses to ensure they do not break when talking to newer daemons.   # Authentication  Authentication for registries is handled client side. The client has to send authentication details to various endpoints that need to communicate with registries, such as `POST /images/(name)/push`. These are sent as `X-Registry-Auth` header as a [base64url encoded](https://tools.ietf.org/html/rfc4648#section-5) (JSON) string with the following structure:  ``` {   \"username\": \"string\",   \"password\": \"string\",   \"email\": \"string\",   \"serveraddress\": \"string\" } ```  The `serveraddress` is a domain/IP without a protocol. Throughout this structure, double quotes are required.  If you have already got an identity token from the [`/auth` endpoint](#operation/SystemAuth), you can just pass this instead of credentials:  ``` {   \"identitytoken\": \"9cbaf023786cd7...\" } ``` 
# The version of the OpenAPI document: 1.41
# 
# Generated by: https://openapi-generator.tech
#


import tables


type FailureAction* {.pure.} = enum
  Continue
  Pause

type Order* {.pure.} = enum
  StopFirst
  StartFirst

type ServiceSpecRollbackConfig* = object
  ## Specification for the rollback strategy of the service.
  parallelism*: int64 ## Maximum number of tasks to be rolled back in one iteration (0 means unlimited parallelism). 
  delay*: int64 ## Amount of time between rollback iterations, in nanoseconds. 
  failureAction*: FailureAction ## Action to take if an rolled back task fails to run, or stops running during the rollback. 
  monitor*: int64 ## Amount of time to monitor each rolled back task for failures, in nanoseconds. 
  maxFailureRatio*: float ## The fraction of tasks that may fail during a rollback before the failure action is invoked, specified as a floating point number between 0 and 1. 
  order*: Order ## The order of operations when rolling back a task. Either the old task is shut down before the new task is started, or the new task is started before the old task is shut down. 

func `%`*(v: FailureAction): JsonNode =
  let str = case v:
    of FailureAction.Continue: "continue"
    of FailureAction.Pause: "pause"

  JsonNode(kind: JString, str: str)

func `$`*(v: FailureAction): string =
  result = case v:
    of FailureAction.Continue: "continue"
    of FailureAction.Pause: "pause"

func `%`*(v: Order): JsonNode =
  let str = case v:
    of Order.StopFirst: "stop-first"
    of Order.StartFirst: "start-first"

  JsonNode(kind: JString, str: str)

func `$`*(v: Order): string =
  result = case v:
    of Order.StopFirst: "stop-first"
    of Order.StartFirst: "start-first"
