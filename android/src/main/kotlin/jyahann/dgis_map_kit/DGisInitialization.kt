package jyahann.dgis_map_kit

import ru.dgis.sdk.ApiKeys
import ru.dgis.sdk.Context
import ru.dgis.sdk.DGis

fun initializeDGis(appContext: android.content.Context, key: String): Context {
    return DGis.initialize(
        appContext,
        ApiKeys(
            map = key,
            directory = "",
        ),
    )
}
