#!/usr/bin/env python3
"""
Simple helper function to calculate start and end indexes for pagination.
"""

def index_range(page: int, page_size: int) -> tuple:
    """
    Returns a tuple containing the start index and end index
    """
    start_index = (page - 1) * page_size
    end_index = page * page_size
    return (start_index, end_index)
