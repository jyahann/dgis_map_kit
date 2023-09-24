package jyahann.dgis_map_kit

import ru.dgis.sdk.Context
import ru.dgis.sdk.DGis
import ru.dgis.sdk.KeyFromString
import ru.dgis.sdk.KeySource

fun initializeDGis(appContext: android.content.Context, key: String): Context {
    return DGis.initialize(
        appContext,
        keySource = KeySource(fromString = KeyFromString(key)),
    )
}
