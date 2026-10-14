# retry seadistus
def get_retry_settings():
    """Loeb Supabase retry-seadistused config.yaml failist."""
    config = load_config()

    supabase_config = config["supabase"]

    max_retries = supabase_config["max_retries"]
    retry_delay_seconds = supabase_config["retry_delay_seconds"]

    return max_retries, retry_delay_seconds
