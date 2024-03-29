import {ThrottleDevice} from "./model_throttle_device.nim";
import {Name, RestartPolicy} from "./model_restart_policy.nim";
import {ResourcesUlimitsInner} from "./model_resources_ulimits_inner.nim";
import {ResourcesBlkioWeightDeviceInner} from "./model_resources_blkio_weight_device_inner.nim";
import {DeviceRequest} from "./model_device_request.nim";
import {DeviceMapping} from "./model_device_mapping.nim";
//
// Docker Engine API
// 
// The Engine API is an HTTP API served by Docker Engine. It is the API the Docker client uses to communicate with the Engine, so everything the Docker client can do can be done with the API.  Most of the client's commands map directly to API endpoints (e.g. docker ps is GET /containers/json). The notable exception is running containers, which consists of several API calls.  // Errors  The API uses standard HTTP status codes to indicate the success or failure of the API call. The body of the response will be JSON in the following format:   {   \"message\": \"page not found\" }   // Versioning  The API is usually changed in each release, so API calls are versioned to ensure that clients don't break. To lock to a specific version of the API, you prefix the URL with its version, for example, call /v1.30/info to use the v1.30 version of the /info endpoint. If the API version specified in the URL is not supported by the daemon, a HTTP 400 Bad Request error message is returned.  If you omit the version-prefix, the current version of the API (v1.41) is used. For example, calling /info is the same as calling /v1.41/info. Using the API without a version-prefix is deprecated and will be removed in a future release.  Engine releases in the near future should support this version of the API, so your client will continue to work even if it is talking to a newer Engine.  The API uses an open schema model, which means server may add extra properties to responses. Likewise, the server will ignore any extra query parameters and request body properties. When you write clients, you need to ignore additional properties in responses to ensure they do not break when talking to newer daemons.   // Authentication  Authentication for registries is handled client side. The client has to send authentication details to various endpoints that need to communicate with registries, such as POST /images/(name)/push. These are sent as X-Registry-Auth header as a [base64url encoded](https://tools.ietf.org/html/rfc4648//section-5) (JSON) string with the following structure:   {   \"username\": \"string\",   \"password\": \"string\",   \"email\": \"string\",   \"serveraddress\": \"string\" }   The serveraddress is a domain/IP without a protocol. Throughout this structure, double quotes are required.  If you have already got an identity token from the [/auth endpoint](//operation/SystemAuth), you can just pass this instead of credentials:   {   \"identitytoken\": \"9cbaf023786cd7...\" }  
// The version of the OpenAPI document: 1.41
// 
// Generated by: https://openapi-generator.tech
//









 
export interface ContainerUpdateRequest {

  // 
  cpuShares:Number // AnNumbereger value representing this container's relative CPU weight versus other containers. 
  memory:Number // Memory limit in bytes.
  cgroupParent: string // Path to cgroups under which the container's cgroup is created. If the path is not absolute, the path is considered to be relative to the cgroups path of the init process. Cgroups are created if they do not already exist. 
  blkioWeight:Number // Block IO weight (relative weight).
  blkioWeightDevice: [Resources_BlkioWeightDevice_inner] // Block IO weight (relative device weight) in the form:   [{\"Path\": \"device_path\", \"Weight\": weight}]  
  blkioDeviceReadBps: [ThrottleDevice] // Limit read rate (bytes per second) from a device, in the form:   [{\"Path\": \"device_path\", \"Rate\": rate}]  
  blkioDeviceWriteBps: [ThrottleDevice] // Limit write rate (bytes per second) to a device, in the form:   [{\"Path\": \"device_path\", \"Rate\": rate}]  
  blkioDeviceReadIOps: [ThrottleDevice] // Limit read rate (IO per second) from a device, in the form:   [{\"Path\": \"device_path\", \"Rate\": rate}]  
  blkioDeviceWriteIOps: [ThrottleDevice] // Limit write rate (IO per second) to a device, in the form:   [{\"Path\": \"device_path\", \"Rate\": rate}]  
  cpuPeriod:Number // The length of a CPU period in microseconds.
  cpuQuota:Number // Microseconds of CPU time that the container can get in a CPU period. 
  cpuRealtimePeriod:Number // The length of a CPU real-time period in microseconds. Set to 0 to allocate no time allocated to real-time tasks. 
  cpuRealtimeRuntime:Number // The length of a CPU real-time runtime in microseconds. Set to 0 to allocate no time allocated to real-time tasks. 
  cpusetCpus: string // CPUs in which to allow execution (e.g., 0-3, 0,1). 
  cpusetMems: string // Memory nodes (MEMs) in which to allow execution (0-3, 0,1). Only effective on NUMA systems. 
  devices: [DeviceMapping] // A list of devices to add to the container.
  deviceCgroupRules: [string] // a list of cgroup rules to apply to the container
  deviceRequests: [DeviceRequest] // A list of requests for devices to be sent to device drivers. 
  kernelMemory:Number // Kernel memory limit in bytes.  <p><br /></p>  > **Deprecated*: This field is deprecated as the kernel 5.4 deprecated > kmem.limit_in_bytes. 
  kernelMemoryTCP:Number // Hard limit for kernel TCP buffer memory (in bytes).
  memoryReservation:Number // Memory soft limit in bytes.
  memorySwap:Number // Total memory limit (memory + swap). Set as -1 to enable unlimited swap. 
  memorySwappiness:Number // Tune a container's memory swappiness behavior. Accepts anNumbereger between 0 and 100. 
  nanoCpus:Number // CPU quota in units of 10<sup>-9</sup> CPUs.
  oomKillDisable: Boolean // Disable OOM Killer for the container.
  init: Boolean // Run an init inside the container that forwards signals and reaps processes. This field is omitted if empty, and the default (as configured on the daemon) is used. 
  pidsLimit:Number // Tune a container's PIDs limit. Set 0 or -1 for unlimited, or null to not change. 
  ulimits: [Resources_Ulimits_inner] // A list of resource limits to set in the container. For example:   {\"Name\": \"nofile\", \"Soft\": 1024, \"Hard\": 2048}  
  cpuCount:Number // The number of usable CPUs (Windows only).  On Windows Server containers, the processor resource controls are mutually exclusive. The order of precedence is CPUCount first, then CPUShares, and CPUPercent last. 
  cpuPercent:Number // The usable percentage of the available CPUs (Windows only).  On Windows Server containers, the processor resource controls are mutually exclusive. The order of precedence is CPUCount first, then CPUShares, and CPUPercent last. 
  iOMaximumIOps:Number // Maximum IOps for the container system drive (Windows only)
  iOMaximumBandwidth:Number // Maximum IO in bytes per second for the container system drive (Windows only). 
  restartPolicy: RestartPolicy
}

    