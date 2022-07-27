import {PortBinding} from "./model_port_binding.nim";
import {EndpointSettings} from "./model_endpoint_settings.nim";
import {Address} from "./model_address.nim";
//
// Docker Engine API
// 
// The Engine API is an HTTP API served by Docker Engine. It is the API the Docker client uses to communicate with the Engine, so everything the Docker client can do can be done with the API.  Most of the client's commands map directly to API endpoints (e.g. docker ps is GET /containers/json). The notable exception is running containers, which consists of several API calls.  // Errors  The API uses standard HTTP status codes to indicate the success or failure of the API call. The body of the response will be JSON in the following format:   {   \"message\": \"page not found\" }   // Versioning  The API is usually changed in each release, so API calls are versioned to ensure that clients don't break. To lock to a specific version of the API, you prefix the URL with its version, for example, call /v1.30/info to use the v1.30 version of the /info endpoint. If the API version specified in the URL is not supported by the daemon, a HTTP 400 Bad Request error message is returned.  If you omit the version-prefix, the current version of the API (v1.41) is used. For example, calling /info is the same as calling /v1.41/info. Using the API without a version-prefix is deprecated and will be removed in a future release.  Engine releases in the near future should support this version of the API, so your client will continue to work even if it is talking to a newer Engine.  The API uses an open schema model, which means server may add extra properties to responses. Likewise, the server will ignore any extra query parameters and request body properties. When you write clients, you need to ignore additional properties in responses to ensure they do not break when talking to newer daemons.   // Authentication  Authentication for registries is handled client side. The client has to send authentication details to various endpoints that need to communicate with registries, such as POST /images/(name)/push. These are sent as X-Registry-Auth header as a [base64url encoded](https://tools.ietf.org/html/rfc4648//section-5) (JSON) string with the following structure:   {   \"username\": \"string\",   \"password\": \"string\",   \"email\": \"string\",   \"serveraddress\": \"string\" }   The serveraddress is a domain/IP without a protocol. Throughout this structure, double quotes are required.  If you have already got an identity token from the [/auth endpoint](//operation/SystemAuth), you can just pass this instead of credentials:   {   \"identitytoken\": \"9cbaf023786cd7...\" }  
// The version of the OpenAPI document: 1.41
// 
// Generated by: https://openapi-generator.tech
//







 
export interface NetworkSettings {

  // NetworkSettings exposes the network settings in the API
  bridge: string // Name of the network'a bridge (for example, docker0).
  sandboxID: string // SandboxID uniquely represents a container's network stack.
  hairpinMode: Boolean // Indicates if hairpin NAT should be enabled on the virtualNumbererface. 
  linkLocalIPv6Address: string // IPv6 unicast address using the link-local prefix.
  linkLocalIPv6PrefixLen:Number // Prefix length of the IPv6 unicast address.
  ports: Table[string, [PortBinding]] // PortMap describes the mapping of container ports to host ports, using the container's port-number and protocol as key in the format <port>/<protocol>, for example, 80/udp.  If a container's port is mapped for multiple protocols, separate entries are added to the mapping table. 
  sandboxKey: string // SandboxKey identifies the sandbox
  secondaryIPAddresses: [Address] // 
  secondaryIPv6Addresses: [Address] // 
  endpointID: string // EndpointID uniquely represents a service endpoint in a Sandbox.  <p><br /></p>  > **Deprecated*: This field is only propagated when attached to the > default \"bridge\" network. Use the information from the \"bridge\" > network inside the Networks map instead, which contains the same > information. This field was deprecated in Docker 1.9 and is scheduled > to be removed in Docker 17.12.0 
  gateway: string // Gateway address for the default \"bridge\" network.  <p><br /></p>  > **Deprecated*: This field is only propagated when attached to the > default \"bridge\" network. Use the information from the \"bridge\" > network inside the Networks map instead, which contains the same > information. This field was deprecated in Docker 1.9 and is scheduled > to be removed in Docker 17.12.0 
  globalIPv6Address: string // Global IPv6 address for the default \"bridge\" network.  <p><br /></p>  > **Deprecated*: This field is only propagated when attached to the > default \"bridge\" network. Use the information from the \"bridge\" > network inside the Networks map instead, which contains the same > information. This field was deprecated in Docker 1.9 and is scheduled > to be removed in Docker 17.12.0 
  globalIPv6PrefixLen:Number // Mask length of the global IPv6 address.  <p><br /></p>  > **Deprecated*: This field is only propagated when attached to the > default \"bridge\" network. Use the information from the \"bridge\" > network inside the Networks map instead, which contains the same > information. This field was deprecated in Docker 1.9 and is scheduled > to be removed in Docker 17.12.0 
  iPAddress: string // IPv4 address for the default \"bridge\" network.  <p><br /></p>  > **Deprecated*: This field is only propagated when attached to the > default \"bridge\" network. Use the information from the \"bridge\" > network inside the Networks map instead, which contains the same > information. This field was deprecated in Docker 1.9 and is scheduled > to be removed in Docker 17.12.0 
  iPPrefixLen:Number // Mask length of the IPv4 address.  <p><br /></p>  > **Deprecated*: This field is only propagated when attached to the > default \"bridge\" network. Use the information from the \"bridge\" > network inside the Networks map instead, which contains the same > information. This field was deprecated in Docker 1.9 and is scheduled > to be removed in Docker 17.12.0 
  iPv6Gateway: string // IPv6 gateway address for this network.  <p><br /></p>  > **Deprecated*: This field is only propagated when attached to the > default \"bridge\" network. Use the information from the \"bridge\" > network inside the Networks map instead, which contains the same > information. This field was deprecated in Docker 1.9 and is scheduled > to be removed in Docker 17.12.0 
  macAddress: string // MAC address for the container on the default \"bridge\" network.  <p><br /></p>  > **Deprecated*: This field is only propagated when attached to the > default \"bridge\" network. Use the information from the \"bridge\" > network inside the Networks map instead, which contains the same > information. This field was deprecated in Docker 1.9 and is scheduled > to be removed in Docker 17.12.0 
  networks: {[key:string]: EndpointSettings} // Information about all networks that the container is connected to. 
}

    