from numpy cimport ndarray, dtype


cdef class BaseChunk:
    cdef object _fill_value
    cdef char *_cname
    cdef int _clevel
    cdef int _shuffle
    cdef tuple _shape
    cdef dtype _dtype
    cdef size_t _size
    cdef size_t _itemsize
    cdef size_t _nbytes
    # override in sub-classes
    cdef void get(self, char *dest)
    cdef void put(self, char *source)


cdef class Chunk(BaseChunk):
    cdef char *_data
    cdef size_t _nbytes
    cdef size_t _blocksize
    cdef void clear(self)
    cdef void free(self)


cdef class SynchronizedChunk(Chunk):
    cdef object _lock


cdef class PersistentChunk(BaseChunk):
    cdef object _path
    cdef object _basename
    cdef object _dirname
    cdef dict read_header(self)
    cdef bytes read(self)
    cdef void write(self, bytes data)


cdef class SynchronizedPersistentChunk(PersistentChunk):
    # TODO
    pass


cdef class BaseArray:
    cdef tuple _shape
    cdef tuple _chunks
    cdef dtype _dtype
    cdef size_t _size
    cdef size_t _itemsize
    cdef size_t _nbytes
    cdef bytes _cname
    cdef int _clevel
    cdef int _shuffle
    cdef object _fill_value
    # override in sub-classes
    cdef void init_chunks(self)
    cdef BaseChunk create_chunk(self, tuple cidx)
    cdef BaseChunk get_chunk(self, tuple cidx)


cdef class Array(BaseArray):
    pass


cdef class PersistentArray(BaseArray):
    cdef object _mode
    cdef object _path