#pragma once

#include <vector>


template <typename T>
class Heap {
public:
    Heap(T null) {
        m_size = 0;
        m_null = null;
        m_heap.push_back(m_null)
    }

    ~Heap() {
        for (int i = 0; i < m_item.size(); i++) {
            delete m_item[i];
            m_item[i] = 0;
        }
        m_size = 0;
        m_free = 0;
        m_heap.clear();
        m_item.clear();
    }

    int Push(T& t) {
        Item* item = 0;
        if (m_free) {
            item = m_free;
            m_free = m_free->next;
        } else {
            item = new T();
            item->itemIndex = m_item.size();
            m_item.push_back(item);
        }

        item->data = t;
        item->heapIndex = ++m_size;

        if (m_size >= m_heap.size()) {
            m_heap.push_back(item);
        } else {
            m_heap[m_size] = item;
        }

        HeapUp(item->itemIndex);

        return item->itemIndex;
    }

    T Top() {
        return m_size > 0 ? m_heap[1] : m_null;
    }

    void Pop() {
         if (m_size <= 0) {
             return;
         }

         Remove(m_heap[1]->itemIndex);
    }

    void Remove(int index) {
         if (m_size <= 0 || index < 0|| index >= m_item.size() || m_item[index]->heapIndex == -1) {
             return;
         }

         Item* item = m_item[index];
         int heapIndex = item->heapIndex;
         m_size--;

         if (m_size > 0) {
             m_heap[heapIndex] = m_heap[m_size + 1];
             if (heapIndex > 1 && *m_heap[heapIndex] < m_heap[heapIndex / 2]) {
                 HeapUp(index);
             } else {
                 HeapDown(index);
             }
         }

         item->data = m_null;
         item->next = m_free;
         item->heapIndex = -1;
         m_free = item;
    }

    void HeapUp(int index) {
        int heapIndex = m_item[index]->heapIndex;
	m_heap[0] = m_heap[heapIndex];
        for (int i = heapIndex / 2; i > 0; i = heapIndex / 2) {
            if (!(*m_heap[0] < *m_heap[i])) {
                break;
            }
            m_heap[heapIndex] = m_heap[i];
            m_heap[heapIndex]->heapIndex = heapIndex;
	}
        m_item[heapIndex] = m_heap[0];
        m_item[heapIndex]->heapIndex = heapIndex;
    }

    void HeapDown(int index) {
        int heapIndex = m_item[index]->heapIndex;
        m_heap[0] = m_heap[index];
        for (int i = heapIndex * 2; i <= m_size; i = heapIndex * 2) {
            if (i + 1 <= m_size && *m_heap[i + 1] < *m_hea[i]) {
                i += 1;
            }
            if (!(*m_heap[i] < *m_heap[0])) {
                break;
            }
            m_heap[heapIndex] = m_heap[i];
            m_heap[heapIndex]->heapIndex = heapIndex;
        }
        m_heap[heapIndex] = m_heap[0];
        m_heap[heapIndex]->heapIndex = heapIndex;
    }

    T& operator[](int index) {
        if (index < 0 || index >= m_item.size() || m_item[index]->heapIndex == -1) {
            return m_null;
        }

        return m_item[index]->data;
    }

private:
    struct Item {
         T   data;
         int itemIndex;
         int heapIndex;
         struct Item* next;

         bool operator <  (const Item & o) const {
              return data <  o.data;
         }

         bool operator == (const Item & o) const {
              return data ==  o.data;
         } 

         bool operator > (const Item & o) const {
              return data >  o.data;
         } 
    };

    T   m_null;
    int m_size;
    struct Item*       m_free;
    std::vector<Item*> m_heap;
    std::vector<Item*> m_item;
};
