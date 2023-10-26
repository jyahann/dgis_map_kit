class DGisMapConfig(creationParams: Map<String?, Any?>?) {
    var token: String
    var isClusteringEnabled: Boolean

    init {
        this.token = creationParams?.get("token") as String
        this.isClusteringEnabled = creationParams?.get("isClusteringEnabled") as Boolean
    }
}
